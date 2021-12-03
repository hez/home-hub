defmodule HomeHub.Thermostat.Status do
  defstruct fan_on: false,
            heater_on: false,
            heating: false,
            humidity: 0.0,
            target: 15.0,
            temperature: 15.0

  @type t :: %__MODULE__{
          fan_on: boolean(),
          heater_on: boolean(),
          heating: boolean(),
          humidity: float(),
          target: float(),
          temperature: float()
        }
end
