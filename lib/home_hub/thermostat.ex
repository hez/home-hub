defmodule HomeHub.Thermostat do
  @moduledoc """
  `Thermostat`
  """

  use GenServer

  require Logger

  alias HomeHub.Thermostat

  @minimum_target 10
  @maximum_target 25
  @poll_interval 30 * 1000

  @name __MODULE__

  def start_link(_opts) do
    GenServer.start_link(@name, %{status: %Thermostat.Status{}}, name: @name)
  end

  @impl true
  def init(state) do
    queue_poll()
    Thermostat.PubSub.subscribe(:temperature)
    {:ok, state}
  end

  def status, do: GenServer.call(@name, :status)

  def start_heat, do: GenServer.cast(@name, {:set_heating, true})
  def stop_heat, do: GenServer.cast(@name, {:set_heating, false})

  @spec(adjust_target_by(float()) :: :ok, {:error, atom()})
  def adjust_target_by(value), do: set_target(status().target + value)

  @spec(set_target(float()) :: :ok, {:error, atom()})
  def set_target(target) when target > @minimum_target and target < @maximum_target do
    Logger.debug("#{target}", label: :new_target)
    GenServer.cast(@name, {:set_target, target})
    :ok
  end

  def set_target(_), do: {:error, :outside_range}

  @impl true
  def handle_call(:status, _from, state), do: {:reply, state.status, state}

  @impl true
  def handle_cast({:set_heating, value}, state) when is_boolean(value) do
    state = update_status(state, :heating, value)
    Thermostat.PubSub.broadcast(:thermostat, {:thermostat, state.status})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:set_target, new_target}, state) do
    state = update_status(state, :target, new_target)
    Thermostat.PubSub.broadcast(:thermostat, {:thermostat, state.status})
    {:noreply, state}
  end

  @impl true
  def handle_info(:poll, %{status: %{heating: heating, heater_on: heater, fan_on: fan}} = state)
      when heating or heater or fan do
    Logger.debug("poll #{inspect(state)}")

    state =
      state
      |> update_pid_set_point()
      |> update_pid()
      |> get_pid_output()
      |> tap(&Logger.debug(inspect(&1), label: :new_pid_value))
      |> update_state_and_broadcast(state)
      |> tap(&Logger.debug(inspect(&1), label: :new_state_from_poll))

    Thermostat.PubSub.broadcast(:thermostat, {:thermostat, state.status})
    queue_poll()
    {:noreply, state}
  end

  def handle_info(:poll, state) do
    Logger.debug("Heating, heater_on, fan_on all set to false, nothing to to.")
    queue_poll()
    {:noreply, state}
  end

  @impl true
  def handle_info(%{temperature: new_t, humidity: new_h}, state) do
    Logger.debug("got new temp and hum, #{new_t} / #{new_h}")
    state = state |> update_status(:temperature, new_t) |> update_status(:humidity, new_h)
    Thermostat.PubSub.broadcast(:thermostat, {:thermostat, state.status})
    {:noreply, state}
  end

  defp pidex_pid, do: Process.whereis(Pidex.PdxServer)

  @spec update_status(map(), atom(), any()) :: map()
  defp update_status(%{status: status} = state, key, value),
    do: %{state | status: Map.put(status, key, value)}

  defp queue_poll, do: Process.send_after(self(), :poll, @poll_interval)

  defp update_pid_set_point(%{status: %{target: t}} = state) do
    Pidex.PdxServer.set(pidex_pid(), set_point: t)
    state
  end

  defp update_pid(%{status: %{temperature: t}} = state) do
    Pidex.PdxServer.update_async(pidex_pid(), t)
    state
  end

  defp get_pid_output(_), do: Pidex.PdxServer.output(pidex_pid())

  # Heating turned ON
  defp update_state_and_broadcast(pid_val, %{status: %{heating: true}} = state)
       when pid_val > 0 do
    # Thermostat.PubSub.broadcast(:fan, {:fan, true})
    Thermostat.PubSub.broadcast(:heater, {:heater, true})
    state |> update_status(:fan_on, true) |> update_status(:heater_on, true)
  end

  defp update_state_and_broadcast(_, state) do
    # Thermostat.PubSub.broadcast(:fan, {:fan, false})
    Thermostat.PubSub.broadcast(:heater, {:heater, false})
    state |> update_status(:fan_on, false) |> update_status(:heater_on, false)
  end
end
