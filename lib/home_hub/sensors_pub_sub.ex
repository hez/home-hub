defmodule HomeHub.SensorsPubSub do
  @moduledoc false
  @topics %{
    thermostat_changes: "thermostat_changes",
    thermostat_sensors: "thermostat_sensors",
    sensor_status: "sensor_status"
  }

  def subscribe(topic), do: Phoenix.PubSub.subscribe(__MODULE__, topic_name(topic))
  def topic_name(name), do: @topics[name]
  def broadcast(topic, event), do: Phoenix.PubSub.broadcast(__MODULE__, topic_name(topic), event)
end
