defmodule HomeHub.Thermostat do
  use GenServer

  require Logger

  alias HomeHub.Thermostat

  @minimum_target 10
  @maximum_target 25
  @float_precision 1
  @poll_interval 30 * 1000

  @name __MODULE__

  def start_link(opts) do
    handler = Keyword.get(opts, :handler)
    GenServer.start_link(@name, %{handler: handler, status: %Thermostat.Status{}}, name: @name)
  end

  def status, do: GenServer.call(@name, {:status})
  def homebridge_status, do: Thermostat.Homebridge.convert(status())

  def start_heat do
    Logger.debug("Turning ON heater")
    GenServer.cast(@name, {:heat_on})
  end

  def stop_heat do
    Logger.debug("Turning OFF heater")
    GenServer.cast(@name, {:heat_off})
  end

  @spec(set_target(float()) :: :ok, {:error, atom()})
  def set_target(target) when target > @minimum_target and target < @maximum_target do
    Logger.debug("#{target}", label: :new_target)
    GenServer.cast(@name, {:set_target, target})
    :ok
  end

  def set_target(_), do: {:error, :outside_range}

  @spec(adjust_target_by(float()) :: :ok, {:error, atom()})
  def adjust_target_by(value), do: set_target(status().target + value)

  def update(%{temperature: _, humidity: _} = vals), do: GenServer.cast(@name, {:set, vals})

  @impl true
  def init(state) do
    queue_poll()
    {:ok, state}
  end

  @impl true
  def handle_call({:status}, _from, state), do: {:reply, state.status, state}

  @impl true
  def handle_cast({:heat_on}, state), do: {:noreply, update_status(state, :heating, true)}

  @impl true
  def handle_cast({:heat_off}, state), do: {:noreply, update_status(state, :heating, false)}

  @impl true
  def handle_cast({:set_target, new_target}, state),
    do: {:noreply, update_status(state, :target, new_target)}

  @impl true
  def handle_cast({:set, %{temperature: t, humidity: h}}, state) do
    {:noreply,
     state
     |> update_status(:humidity, Float.round(h, @float_precision))
     |> update_status(:temperature, Float.round(t, @float_precision))}
  end

  @impl true
  def handle_info(:poll, %{status: %{heating: heating, heater_on: heater, fan_on: fan}} = state)
      when heating or heater or fan do
    Logger.debug("heating, heater_on, fan_on, updating state.")

    state =
      state
      |> update_pid_set_point()
      |> update_pid()
      |> get_pid_output()
      |> log(label: :new_pid_value)
      |> update_state_from_pid(state)
      |> log(label: :new_state_from_poll)

    state.handler.update(state.status)

    queue_poll()
    # apply(handler, :poll, [status])
    {:noreply, state}
  end

  def handle_info(:poll, state) do
    Logger.debug("Heating, heater_on, fan_on all set to false, nothing to to.")
    queue_poll()
    {:noreply, state}
  end

  defp log(value, opts) do
    Logger.debug("#{inspect(value)}", opts)
    value
  end

  defp queue_poll, do: Process.send_after(self(), :poll, @poll_interval)

  defp pidex_pid, do: Process.whereis(Pidex.PdxServer)

  defp update_pid_set_point(state) do
    Pidex.PdxServer.set(pidex_pid(), set_point: state.status.target)
    state
  end

  defp update_pid(state) do
    Pidex.PdxServer.update_async(pidex_pid(), state.status.temperature)
    state
  end

  defp get_pid_output(_), do: Pidex.PdxServer.output(pidex_pid())

  # Heating turned ON
  defp update_state_from_pid(pid_val, %{status: %{heating: true}} = state) when pid_val > 0,
    do: state |> update_status(:fan_on, true) |> update_status(:heater_on, true)

  defp update_state_from_pid(_, state),
    do: state |> update_status(:fan_on, false) |> update_status(:heater_on, false)

  @spec update_status(map(), atom(), any()) :: map()
  defp update_status(%{status: status} = state, key, value),
    do: %{state | status: Map.put(status, key, value)}
end
