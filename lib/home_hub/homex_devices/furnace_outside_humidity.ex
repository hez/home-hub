defmodule HomeHub.HomexDevice.FurnaceOutsideHumidity do
  use Homex.Entity.Sensor,
    name: "furnace-outside-humidity-dev",
    unit_of_measurement: "%",
    device_class: "humidity"

  def handle_init(entity) do
    HomeHub.SensorsPubSub.subscribe(:thermostat_sensor) |> dbg()
    super(entity)
  end

  def handle_info(%{name: "thermostat_outdoor", humidity: hum}, entity) do
    dbg(hum)
    set_value(entity, hum)
  end
end
