defmodule HomeHub.Model.TemperatureSensor do
  import HomeHub, only: [to_f: 1]

  @derive Jason.Encoder
  defstruct [:name, :temperature, :humidity, :pressure, :battery, :lastseen, :type]

  @type t :: %__MODULE__{
          name: String.t(),
          temperature: float(),
          humidity: float(),
          pressure: float(),
          battery: integer() | nil,
          lastseen: DateTime.t() | nil,
          type: String.t() | nil
        }

  @days_for_sensor_stale 2
  @local_tz "America/Vancouver"

  def new(%{} = data) do
    sensor = struct(__MODULE__, Map.take(data, [:name, :battery, :type]))

    %{
      sensor
      | temperature: data |> Map.get(:temperature) |> to_f(),
        humidity: data |> Map.get(:humidity) |> to_f(),
        pressure: data |> Map.get(:pressure) |> to_f(),
        lastseen: Map.get(data, :lastseen, DateTime.utc_now())
    }
  end

  def new(data) when is_list(data), do: data |> Map.new() |> new()

  def alertable?(%__MODULE__{battery: nil}), do: false

  def alertable?(%__MODULE__{battery: battery} = sensor) do
    stale_date = DateTime.utc_now() |> DateTime.shift(day: -@days_for_sensor_stale)
    battery < 20 or DateTime.before?(sensor.lastseen || DateTime.utc_now(), stale_date)
  end

  def local_lastseen(%__MODULE__{lastseen: %DateTime{} = lastseen}),
    do: DateTime.shift_zone!(lastseen, @local_tz)

  def local_lastseen(_), do: nil
end
