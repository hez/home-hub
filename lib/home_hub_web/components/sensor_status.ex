defmodule HomeHubWeb.SensorStatus do
  import Phoenix.LiveView
  use Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    if connected?(socket) do
      HomeHub.SensorsPubSub.subscribe(:sensor_status)
    end

    {:cont, assign(socket, sensors: HomeHub.SensorsServer.all())}
  end
end
