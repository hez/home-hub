defmodule HomeHub.Sensors do
  @filtered_sensor_names ["RWL022 34"]
  @days_for_sensor_stale 2
  @local_tz "America/Vancouver"

  def alertable?(%{} = sensors) do
    sensors
    |> Enum.reject(&filter_sensor/1)
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

  defp filter_sensor({name, _}) when name in @filtered_sensor_names, do: true
  defp filter_sensor(_), do: false
end
