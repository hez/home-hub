defmodule HomeHub.Thermostat.Daikin do
  require Logger
  alias DaikinOne.DeviceServer
  alias HomeHub.HAP.DaikinThermostat

  @behaviour ExThermostat

  @spec device_info() :: DaikinOne.DeviceInformation.t()
  def device_info do
    case DeviceServer.device() do
      %{information: %DaikinOne.DeviceInformation{} = info} -> info
      _ -> DeviceServer.empty_device_information()
    end
  end

  @impl ExThermostat
  def status, do: to_thermostat(device_info())

  @impl ExThermostat
  def set_mode(mode) do
    status = device_info()
    DeviceServer.push_update(mode, to_f(status.heat_setpoint), to_f(status.cool_setpoint))
    :ok
  end

  @impl ExThermostat
  def toggle_mode(mode) do
    mode = if status().mode == mode, do: :off, else: mode
    set_mode(mode)
  end

  @impl ExThermostat
  def set_target(target) do
    status = DaikinThermostat.state()

    case status.mode do
      :heat ->
        DeviceServer.push_update(status.mode, to_f(target), to_f(status.cool_setpoint))

      :cool ->
        DeviceServer.push_update(status.mode, to_f(status.heat_setpoint), to_f(target))

      other ->
        Logger.warning("Unsupported starget in mode #{inspect(other)} for #{inspect(target)}")
    end

    :ok
  end

  @impl ExThermostat
  def adjust_target_by(adjustment) do
    %{target: target} = status()
    set_target(target + adjustment)
    :ok
  end

  @doc """
  Daikin Device Info properties:

  :cool_setpoint,
  :equipment_communication,
  :equipment_status,
  :fan,
  :fan_circulate,
  :fan_circulate_speed,
  :geofencing_enabled,
  :heat_setpoint,
  :hum_indoor,
  :hum_outdoor,
  :mode,
  :mode_em_heat_available,
  :mode_limit,
  :schedule_enabled,
  :setpoint_delta,
  :setpoint_maximum,
  :setpoint_minimum,
  :temp_indoor,
  :temp_outdoor,
  :updated_at
  """
  def to_thermostat(state) do
    target = if state.mode == :cool, do: state.cool_setpoint, else: state.heat_setpoint

    %ExThermostat.Status{
      mode: state.mode,
      equipment_state: state.equipment_status,
      started_at: nil,
      humidity: to_f(state.hum_indoor),
      target: to_f(target),
      temperature: to_f(state.temp_indoor),
      pid: 0.0
    }
  end

  def to_f(val) when is_float(val), do: val
  def to_f(val) when is_integer(val), do: val * 1.0
end
