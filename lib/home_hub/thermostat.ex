defmodule HomeHub.Thermostat do
  @moduledoc """
  `Thermostat`
  """

  use GenServer

  require Logger

  alias HomeHub.Thermostat

  @default_options [
    minimum_target: 10,
    maximum_target: 30,
    poll_interval: 30 * 1000,
    winter_start: ~D[2000-10-01],
    winter_end: ~D[2000-04-01],
    winter_target_temperature: 16.0
  ]

  @name __MODULE__

  def start_link(opts \\ []),
    do: GenServer.start_link(@name, %{status: nil, options: opts}, name: @name)

  @impl true
  def init(state) do
    options = Keyword.merge(@default_options, state.options)
    status = initial_status(options)
    queue_poll(options)
    Thermostat.PubSub.subscribe(:temperature)
    {:ok, %{state | status: status, options: options}}
  end

  @spec status() :: Thermostat.Status.t()
  def status, do: GenServer.call(@name, :status)

  @spec options() :: Keyword.t()
  def options, do: GenServer.call(@name, :options)

  @spec options(atom()) :: any()
  def options(key), do: Keyword.get(options(), key)

  def start_heat, do: GenServer.cast(@name, {:set_heating, true})
  def stop_heat, do: GenServer.cast(@name, {:set_heating, false})

  @spec adjust_target_by(float()) :: :ok | {:error, atom()}
  def adjust_target_by(value) when is_float(value), do: set_target(status().target + value)

  @spec set_target(float() | integer()) :: :ok | {:error, atom()}
  def set_target(target) when is_integer(target), do: set_target(target / 1.0)

  def set_target(target) do
    if target > options(:minimum_target) and target <= options(:maximum_target) do
      Logger.debug("#{target}", label: :new_target)
      GenServer.cast(@name, {:set_target, target})
      :ok
    else
      {:error, :outside_range}
    end
  end

  @spec initial_status(Keyword.t()) :: Thermostat.Status.t()
  def initial_status(options) do
    if winter_mode?(options, Date.utc_today()) do
      %Thermostat.Status{heating: true, target: Keyword.get(options, :winter_target_temperature)}
    else
      %Thermostat.Status{}
    end
  end

  @spec winter_mode?(Keyword.t(), Date.t()) :: boolean()
  def winter_mode?(options, date) do
    Date.compare(date, %{Keyword.get(options, :winter_start) | year: date.year}) === :gt or
      Date.compare(date, %{Keyword.get(options, :winter_end) | year: date.year}) === :lt
  end

  @impl true
  def handle_call(:status, _from, state), do: {:reply, state.status, state}

  @impl true
  def handle_call(:options, _from, state), do: {:reply, state.options, state}

  @impl true
  def handle_cast({:set_heating, value}, state) when is_boolean(value) do
    state = update_status(state, :heating, value)
    Thermostat.PubSub.broadcast(:thermostat, {:heating, value})
    Thermostat.PubSub.broadcast(:thermostat_status, {:thermostat, state.status})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:set_target, new_target}, state) do
    state = update_status(state, :target, new_target)
    Thermostat.PID.update_set_point(new_target)
    Thermostat.PubSub.broadcast(:thermostat, {:target, new_target})
    Thermostat.PubSub.broadcast(:thermostat_status, {:thermostat, state.status})
    {:noreply, state}
  end

  @impl true
  def handle_info(:poll, %{status: %{heating: heating, heater_on: heater} = status} = state)
      when heating or heater do
    Logger.debug("poll #{inspect(state)}")

    output = Thermostat.PID.output(status.temperature)

    state =
      state
      |> update_status(:pid, output)
      |> update_state_and_broadcast()
      |> tap(&Logger.debug(inspect(&1), label: :new_state_from_poll))

    Thermostat.PubSub.broadcast(:thermostat_status, {:thermostat, state.status})
    queue_poll(state.options)
    {:noreply, state}
  end

  def handle_info(:poll, state) do
    Logger.debug("Heating, heater_on, fan_on all set to false, nothing to to.")
    queue_poll(state.options)
    {:noreply, state}
  end

  @impl true
  def handle_info(%{temperature: new_t, humidity: new_h}, state) do
    Logger.debug("got new temp and hum, #{new_t} / #{new_h}")
    state = state |> update_status(:temperature, new_t) |> update_status(:humidity, new_h)
    Thermostat.PubSub.broadcast(:thermostat, {:humidity, new_t})
    Thermostat.PubSub.broadcast(:thermostat, {:temperature, new_t})
    Thermostat.PubSub.broadcast(:thermostat_status, {:thermostat, state.status})
    {:noreply, state}
  end

  @spec update_status(map(), atom(), any()) :: map()
  defp update_status(%{status: status} = state, key, value),
    do: %{state | status: Thermostat.Status.update(status, key, value)}

  defp queue_poll(options),
    do: Process.send_after(self(), :poll, Keyword.get(options, :poll_interval, 30 * 1000))

  # Heating turned ON
  defp update_state_and_broadcast(%{status: %{heating: true, pid: pid_val}} = state)
       when pid_val > 0 do
    Thermostat.PubSub.broadcast(:heater, {:heater, true})
    state |> update_status(:heater_on, true)
  end

  defp update_state_and_broadcast(state) do
    Thermostat.PubSub.broadcast(:heater, {:heater, false})
    state |> update_status(:heater_on, false)
  end
end
