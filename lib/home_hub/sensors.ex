defmodule HomeHub.Sensors do
  @days_for_sensor_stale 2
  @local_tz "America/Vancouver"

  def alertable?(%{} = sensors) do
    sensors
    |> Enum.filter(&alertable?/1)
    |> Enum.count() != 0
  end

  def alertable?({_, sensor}) do
    stale_date = DateTime.utc_now() |> DateTime.shift(day: -@days_for_sensor_stale)
    sensor.battery < 20 or DateTime.before?(sensor.lastseen || DateTime.utc_now(), stale_date)
  end

  def local_lastseen(%{lastseen: %DateTime{} = lastseen}),
    do: DateTime.shift_zone!(lastseen, @local_tz)

  def local_lastseen(_), do: nil
end
