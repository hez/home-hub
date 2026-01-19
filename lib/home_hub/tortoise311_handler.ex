defmodule HomeHub.Tortoise311Handler do
  # zigbee2mqtt/temperature bedroom "{\"battery\":90,\"humidity\":73.38,\"linkquality\":102,\"power_outage_count\":178,\"pressure\":1022.8,\"temperature\":17.33,\"voltage\":2985}"
  use Tortoise311.Handler

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
          temperature: payload["temperature"],
          humidity: payload["humidity"],
          pressure: payload["pressure"],
          battery: payload["battery"],
          lastseen: DateTime.utc_now(),
          type: :temp_humidity
        }

      HomeHub.SensorsServer.set(name, sensor) |> dbg()
    end

    {:ok, state}
  end

  def handle_message(_topic, _payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
