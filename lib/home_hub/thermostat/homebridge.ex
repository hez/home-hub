defmodule HomeHub.Thermostat.Homebridge do
  def convert(state) do
    %{
      currentHeatingCoolingState: heating_state(state),
      currentRelativeHumidity: state.humidity,
      currentTemperature: state.temperature,
      targetHeatingCoolingState: heating_state(state),
      targetTemperature: state.target
    }
  end

  def heating_state(%{heating: true}), do: 1
  def heating_state(_), do: 0
end
