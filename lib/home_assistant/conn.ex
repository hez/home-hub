defmodule HomeAssistant.Conn do
  alias HomeAssistant.MQTTDevice

  if Mix.env() == :prod do
    def client_id, do: "home_hub_client_id"
  else
    def client_id, do: "home_hub_client_id_dev"
  end

  def start do
    Tortoise311.Supervisor.start_child(
      client_id: client_id(),
      handler: {HomeHub.Tortoise311Handler, []},
      server: {Tortoise311.Transport.Tcp, Application.get_env(:home_hub, :tortoise311_config)},
      subscriptions: [{"zigbee2mqtt/#", 0}]
    )

    MQTTDevice.Button.initialize()
  end

  def new do
    %{client_id: client_id()}
  end

  def publish(conn, topic, msg) when is_list(topic),
    do: publish(conn, topic |> Enum.join("/"), msg)

  def publish(conn, topic, %{} = msg), do: publish(conn, topic, Jason.encode!(msg))

  def publish(conn, topic, msg) when is_binary(topic) and (is_binary(msg) or is_nil(msg)),
    do: Tortoise311.publish(conn.client_id, topic, msg, qos: 1)
end
