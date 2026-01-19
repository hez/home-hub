defmodule HomeHub.TemperatureSensor do
  @derive Jason.Encoder
  defstruct [:temperature, :humidity, :pressure, :battery, :lastseen, :type]
end
