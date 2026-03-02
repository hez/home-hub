defmodule HomeHub.Thermostat.Homex do
  use GenServer
  require Logger
  import HomeHub, only: [to_f: 1]

  @behaviour ExThermostat

  @thermostat_entity_id "climate.daikin"
  @sensor_device_classes ["temperature", "humidity", "battery"]
  @initial_current_state_call_delay 30 * 1000
  @current_state_call_delay 1 * 60 * 60 * 1000

  def start_link(__opts) do
    GenServer.start_link(__MODULE__, %{thermostat: %ExThermostat.Status{}}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Homex.WebsocketClient.register("state_changed")
    Homex.WebsocketClient.register("state_current")
    schedule_current_state_call(@initial_current_state_call_delay)
    {:ok, state}
  end

  defp schedule_current_state_call(delay \\ @current_state_call_delay),
    do: Process.send_after(self(), :do_current_state_call, delay)

  @impl GenServer
  def handle_call(:status, _, state), do: {:reply, state.thermostat, state}

  @impl GenServer
  def handle_cast({:update, thermostat}, state) do
    ExThermostat.PubSub.broadcast(:thermostat_status, thermostat)
    {:noreply, %{state | thermostat: thermostat}}
  end

  @impl ExThermostat
  def status, do: GenServer.call(__MODULE__, :status)

  def update(thermostat), do: GenServer.cast(__MODULE__, {:update, thermostat})

  @impl ExThermostat
  def set_mode(mode) do
    thermostat = status()

    msg = %{
      type: :call_service,
      domain: :climate,
      service: :set_temperature,
      target: %{
        entity_id: @thermostat_entity_id
      },
      service_data: %{
        mode: mode
      }
    }

    Homex.WebsocketClient.send(msg)

    update(%{thermostat | mode: mode})
  end

  @impl ExThermostat
  def toggle_mode(mode) do
    mode = if status().mode == mode, do: :off, else: mode
    set_mode(mode)
  end

  @impl ExThermostat
  def set_target(target) do
    thermostat = status()

    msg = %{
      type: :call_service,
      domain: :climate,
      service: :set_temperature,
      target: %{
        entity_id: @thermostat_entity_id
      },
      service_data: %{
        temperature: target
      }
    }

    Homex.WebsocketClient.send(msg)
    update(%{thermostat | target: to_f(target)})
  end

  @impl ExThermostat
  def adjust_target_by(adjustment) do
    thermostat = status()
    set_target(thermostat.target + adjustment)
  end

  @impl GenServer
  def handle_info(:do_current_state_call, state) do
    Homex.WebsocketClient.get_states()
    schedule_current_state_call()
    {:noreply, state}
  end

  # Handle thermostat msgs
  def handle_info(
        {:state_changed, %{entity_id: @thermostat_entity_id, new_state: new_state}},
        state
      ) do
    thermostat = to_thermostat(new_state)
    ExThermostat.PubSub.broadcast(:thermostat_status, thermostat)
    {:noreply, %{state | thermostat: thermostat}}
  end

  # Handle sensor change msgs
  def handle_info(
        {:state_changed,
         %{
           entity_id: entity_id,
           new_state: %{"attributes" => %{"device_class" => dc}} = new_state
         }},
        state
      )
      when dc in @sensor_device_classes do
    update_sensor(entity_id, new_state)
    {:noreply, state}
  end

  # Handle current thermostat msgs
  def handle_info(
        {:state_current, %{entity_id: @thermostat_entity_id, current_state: current_state}},
        state
      ) do
    thermostat = to_thermostat(current_state)
    ExThermostat.PubSub.broadcast(:thermostat_status, thermostat)
    {:noreply, %{state | thermostat: thermostat}}
  end

  # Handle current sensor msgs
  def handle_info(
        {:state_current,
         %{
           entity_id: entity_id,
           current_state: %{"attributes" => %{"device_class" => dc}} = current_state
         }},
        state
      )
      when dc in @sensor_device_classes do
    update_sensor(entity_id, current_state)
    {:noreply, state}
  end

  def handle_info(_event, state) do
    # dbg(event)
    # Logger.error("Unhandled event: #{inspect(event)}")
    {:noreply, state}
  end

  defp update_sensor(entity_id, state) do
    name = state["attributes"]["friendly_name"] |> unify_sensor_name()
    current = HomeHub.SensorsServer.find_or_new(name)

    attrs =
      case state["attributes"]["device_class"] do
        "temperature" -> %{temperature: to_f(state["state"])}
        "humidity" -> %{humidity: to_f(state["state"])}
        "battery" -> %{battery: to_f(state["state"])}
      end
      |> Map.merge(%{entity_id: entity_id})

    HomeHub.SensorsServer.set(name, Map.merge(current, attrs))
  end

  defp to_thermostat(state) do
    %ExThermostat.Status{
      mode: to_atom_mode(state["state"]),
      equipment_state: nil,
      started_at: nil,
      humidity: to_f(state["attributes"]["current_humidity"]),
      target: to_f(state["attributes"]["temperature"]),
      temperature: to_f(state["attributes"]["current_temperature"]),
      pid: 0.0
    }
  end

  defp unify_sensor_name(name) do
    name
    |> String.downcase()
    |> String.replace("temperature", "")
    |> String.replace("humidity", "")
    |> String.replace("battery", "")
    |> String.trim()
  end

  def to_atom_mode(mode) when is_atom(mode), do: mode

  def to_atom_mode(mode) when is_binary(mode) do
    case mode do
      "auto" -> :auto
      "cool" -> :cool
      "heat" -> :heat
      "off" -> :off
      _ -> :unknown
    end
  end
end
