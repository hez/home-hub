defmodule HomeHubWeb.SwitchesComponent do
  use Phoenix.LiveComponent

  @impl true
  def handle_event("press", %{"name" => name}, socket) do
    HomeHub.Switches.press(name)

    {:noreply, socket}
  end
end
