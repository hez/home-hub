defmodule HomeHubWeb.InactivityHandler do
  use Phoenix.Component
  require Logger
  import Phoenix.LiveView

  def on_mount(_, _params, _session, socket) do
    Logger.debug("Mounting InactivityHandler, attaching hooks")
    {:ok, _} = BacklightAutomation.register()
    socket = socket |> attach_hook(:inactivity_handle_info, :handle_info, &hooked_info/2)
    {:cont, socket}
  end

  def hooked_info({:backlight_level_change, state}, socket) do
    if state.active?,
      do: {:cont, socket},
      else: {:halt, push_navigate(socket, to: "/", replace: true)}
  end

  def hooked_info(_msg, socket) do
    {:cont, socket}
  end
end
