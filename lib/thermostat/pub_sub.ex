defmodule Thermostat.PubSub do
  @moduledoc false
  @topics %{
    fan: "fan_io_update",
    heater: "heater_io_update",
    temperature: "temperature_update",
    thermostat: "thermostat_update",
    thermostat_status: "thermostat_status"
  }

  def subscribe(topic), do: Phoenix.PubSub.subscribe(__MODULE__, topic_name(topic))
  def topic_name(name), do: @topics[name]
  def broadcast(topic, event), do: Phoenix.PubSub.broadcast(__MODULE__, topic_name(topic), event)
end
