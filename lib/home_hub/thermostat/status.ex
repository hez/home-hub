defmodule HomeHub.Thermostat.Status do
  defstruct temperature: 15,
            humidity: 0,
            heating: false,
            target: 15.0,
            fan_on: false,
            heater_on: false
end
