defmodule HomeHub.TemperatureSensor do
  @derive Jason.Encoder
  defstruct [:name, :temperature, :humidity, :pressure, :battery, :lastseen, :type]

  def new(%{} = data) do
    sensor = struct(__MODULE__, Map.take(data, [:name, :battery, :type]))

    %{
      sensor
      | temperature: data |> Map.get(:temperature) |> to_float(),
        humidity: data |> Map.get(:humidity) |> to_float(),
        pressure: data |> Map.get(:pressure) |> to_float(),
        lastseen: Map.get(data, :lastseen, DateTime.utc_now())
    }
  end

  def new(data) when is_list(data), do: data |> Map.new() |> new()

  def to_float(val) when is_number(val), do: val * 1.0
  def to_float(_val), do: nil
end
