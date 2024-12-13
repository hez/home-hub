defmodule Thermostat do
  @moduledoc """
  `Thermostat`
  """

  use GenServer

  require Logger

  alias Thermostat.Status

  @poll_interval 30 * 1000
  @default_options [
    minimum_target: 10,
    maximum_target: 30,
    # Minimum heater runtime in minutes
    minimum_runtime: nil,
    poll_interval: @poll_interval,
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

  @spec status() :: Status.t()
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

  @spec initial_status(Keyword.t()) :: Status.t()
  def initial_status(options) do
    if winter_mode?(options, Date.utc_today()) do
      %Status{heating: true, target: Keyword.get(options, :winter_target_temperature)}
    else
      %Status{}
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
  def handle_info(:poll, %{status: %Status{heating: true} = status} = state) do
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

  def handle_info(:poll, %{} = state) do
    Logger.debug("Heating, heater_on, fan_on all set to false, nothing to to.")
    queue_poll(state.options)
    {:noreply, state}
  end

  @impl true
  def handle_info(%{temperature: new_t, humidity: new_h}, %{} = state) do
    Logger.debug("got new temp and hum, #{new_t} / #{new_h}")
    state = state |> update_status(:temperature, new_t) |> update_status(:humidity, new_h)
    Thermostat.PubSub.broadcast(:thermostat, {:humidity, new_t})
    Thermostat.PubSub.broadcast(:thermostat, {:temperature, new_t})
    Thermostat.PubSub.broadcast(:thermostat_status, {:thermostat, state.status})
    {:noreply, state}
  end

  @spec update_status(map(), atom(), any()) :: map()
  defp update_status(%{status: %Status{} = status} = state, key, value) when is_atom(key),
    do: %{state | status: Thermostat.Status.update(status, key, value)}

  defp queue_poll(options) when is_list(options),
    do: Process.send_after(self(), :poll, Keyword.get(options, :poll_interval, @poll_interval))

  # Heating turned ON
  defp update_state_and_broadcast(%{status: %Status{heating: true, pid: pid_val}} = state)
       when pid_val > 0 do
    Thermostat.PubSub.broadcast(:heater, {:heater, true})

    state.status.heater_on
    |> case do
      false -> state |> update_status(:heater_started_at, DateTime.utc_now())
      _ -> state
    end
    |> update_status(:heater_on, true)
  end

  defp update_state_and_broadcast(%{} = state) do
    case can_shutdown?(state) do
      true ->
        Thermostat.PubSub.broadcast(:heater, {:heater, false})
        state |> update_status(:heater_on, false) |> update_status(:heater_started_at, nil)

      false ->
        Logger.warning("Can't shutdown heater yet")
        state
    end
  end

  defp can_shutdown?(%{options: options, status: %Status{} = status}) do
    with true <- status.heating,
         true <- status.heater_on,
         heater_started_at when not is_nil(heater_started_at) <- status.heater_started_at,
         min_rt when not is_nil(min_rt) <- Keyword.get(options, :minimum_runtime) do
      heater_started_at
      |> DateTime.shift(minute: min_rt)
      |> DateTime.compare(DateTime.utc_now()) == :lt
    else
      _ -> true
    end
  end
end
