defmodule HomeHubWeb.InactivityHandler do
  use Phoenix.Component
  require Logger
  import Phoenix.LiveView

  def on_mount(_, _params, _session, socket) do
    Logger.debug("Mounting InactivityHandler, attaching hooks")
    Phoenix.PubSub.subscribe(HomeHub.PubSub, "backlight_automation")
    socket = socket |> attach_hook(:inactivity_handle_info, :handle_info, &hooked_info/2)
    {:cont, socket}
  end

  def hooked_info({:level_change, state}, socket) do
    dbg(state)

    if state.active?,
      do: {:cont, socket},
      else: {:halt, push_navigate(socket, to: "/", replace: true)}
  end

  def hooked_info(_, socket) do
    {:cont, socket}
  end
end
