defmodule HomeHubWeb.SensorStatusHandler do
  use Phoenix.Component
  require Logger
  import Phoenix.LiveView

  def on_mount(_, _params, _session, socket) do
    Logger.debug("Mounting SensorStatusHandler, attaching hooks")
    HomeHub.SensorsPubSub.subscribe(:sensor_status)

    socket =
      socket
      |> assign(sensors: HomeHub.SensorsServer.all())
      |> attach_hook(:sensor_status_handle_info, :handle_info, &hooked_info/2)

    {:cont, socket}
  end

  def hooked_info({:sensor_status, status}, socket),
    do: {:cont, assign(socket, sensors: status)}

  def hooked_info(_, socket), do: {:cont, socket}
end
