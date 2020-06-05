defmodule HomeHubWeb.LightsComponent do
  use Phoenix.LiveComponent

  @impl true
  def handle_event("light_on", %{"name" => name, "level" => level}, socket) do
    name
    |> String.to_atom()
    |> HomeHub.Lights.on(String.to_integer(level))

    updated_lights()
    {:noreply, socket}
  end

  @impl true
  def handle_event("light_off", %{"name" => name}, socket) do
    name
    |> String.to_atom()
    |> HomeHub.Lights.off()

    updated_lights()
    {:noreply, socket}
  end

  defp updated_lights, do: send(self(), :refresh)
end
