defmodule HomeHub.Thermostat.Status do
  @moduledoc false
  defstruct fan_on: false,
            heater_on: false,
            heating: false,
            humidity: 0.0,
            target: 15.0,
            temperature: 15.0,
            pid: 0.0

  @type t :: %__MODULE__{
          fan_on: boolean(),
          heater_on: boolean(),
          heating: boolean(),
          humidity: float(),
          target: float(),
          temperature: float(),
          pid: float()
        }

  @spec update(t(), atom(), any()) :: map()
  def update(%__MODULE__{} = status, key, value),
    do: Map.put(status, key, value)
end
