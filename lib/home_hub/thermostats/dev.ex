defmodule HomeHub.Thermostat.Dev do
  alias HomeHub.HAP.DevThermostat
  @behaviour ExThermostat

  @impl ExThermostat
  def status, do: to_thermostat(DevThermostat.state())

  @impl ExThermostat
  def set_mode(mode) do
    new_state =
      case mode do
        :off -> 0
        :heat -> 1
        :cool -> 2
        :auto -> 3
      end

    DevThermostat.update_state(:target_state, new_state)
    DevThermostat.update_state(:current_state, new_state)
    ExThermostat.PubSub.broadcast(:thermostat_status, status())
    :ok
  end

  @impl ExThermostat
  def toggle_mode(mode) do
    mode = if status().mode == mode, do: :off, else: mode
    set_mode(mode)
  end

  @impl ExThermostat
  def set_target(target) do
    DevThermostat.update_state(:target_temp, target)
    ExThermostat.PubSub.broadcast(:thermostat_status, status())
    :ok
  end

  @impl ExThermostat
  def adjust_target_by(adjustment) do
    %{target: target} = status()
    set_target(target + adjustment)
    :ok
  end

  def set_current_temp(value) do
    DevThermostat.update_state(:current_temp, value)

    HomeHub.SensorsPubSub.broadcast(:thermostat_sensors, [
      %{
        name: "thermostat",
        temperature: status().temperature,
        humidity: status().humidity
      }
    ])

    ExThermostat.PubSub.broadcast(:thermostat_status, status())
    :ok
  end

  def set_current_humidity(value) do
    DevThermostat.update_state(:current_humidity, value)
    ExThermostat.PubSub.broadcast(:thermostat_status, status())
    :ok
  end

  def to_thermostat(state) do
    mode =
      case state.target_state do
        0 -> :off
        1 -> :heat
        2 -> :cool
        3 -> :auto
      end

    %ExThermostat.Status{
      mode: mode,
      equipment_state: :idle,
      started_at: nil,
      humidity: state.current_humidity * 1.0,
      target: state.target_temp * 1.0,
      temperature: state.current_temp * 1.0,
      pid: 0.0
    }
  end
end
