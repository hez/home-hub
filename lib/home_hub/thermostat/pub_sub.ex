defmodule HomeHub.Thermostat.PubSub do
  @topics %{
    fan: "fan_io_update",
    heater: "heater_io_update",
    temperature: "temperature_update",
    thermostat: "thermostat_update"
  }

  def subscribe(topic), do: Phoenix.PubSub.subscribe(HomeHub.Thermostat.PubSub, topic_name(topic))
  def topic_name(name), do: @topics[name]

  def broadcast(topic, event),
    do: Phoenix.PubSub.broadcast(HomeHub.Thermostat.PubSub, topic_name(topic), event)
end
