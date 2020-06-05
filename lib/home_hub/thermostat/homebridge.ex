defmodule HomeHub.Thermostat.Homebridge do
  def convert(state) do
    %{
      targetHeatingCoolingState: heating_state(state),
      targetTemperature: state.target,
      currentHeatingCoolingState: heating_state(state),
      currentTemperature: state.temperature
    }
  end

  def heating_state(%{heating: true}), do: 1
  def heating_state(_), do: 0
end
