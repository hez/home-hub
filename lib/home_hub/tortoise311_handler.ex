defmodule HomeHub.Tortoise311Handler do
  use Tortoise311.Handler
  require Logger

  def init(args) do
    {:ok, args}
  end

  def connection(_status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`
    {:ok, state}
  end

  #  topic filter zigbee2mqtt/device
  def handle_message(["zigbee2mqtt", "temperature " <> <<name::binary>>], payload, state) do
    with {:ok, payload} <- Jason.decode(payload) do
      sensor =
        %HomeHub.TemperatureSensor{
          temperature: to_float(payload["temperature"]),
          humidity: to_float(payload["humidity"]),
          pressure: to_float(payload["pressure"]),
          battery: payload["battery"],
          lastseen: DateTime.utc_now(),
          type: :temp_humidity
        }

      HomeHub.SensorsServer.set(name, sensor) |> dbg()
    else
      error ->
        Logger.warning("Error in MQTT #{inspect(error)}")
    end

    {:ok, state}
  end

  def handle_message(_topic, _payload, state) do
    # dbg(topic)
    # dbg(payload)
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state), do: {:ok, state}

  def terminate(_reason, _state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end

  defp to_float(num) when is_float(num) or is_integer(num), do: num * 1.0
end
