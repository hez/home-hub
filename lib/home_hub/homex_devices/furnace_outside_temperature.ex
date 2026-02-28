defmodule HomeHub.HomexDevice.FurnaceOutsideTemperature do
  use Homex.Entity.Sensor,
    name: "furnace-outside-temperature-dev",
    unit_of_measurement: "°C",
    device_class: "temperature"

  def handle_init(entity) do
    HomeHub.SensorsPubSub.subscribe(:thermostat_sensor)
    super(entity)
  end

  def handle_info(%{name: "thermostat_outdoor", temperature: temp}, entity) do
    set_value(entity, temp)
  end
end
