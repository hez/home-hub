defmodule HomeHubWeb.HomebridgeSwitchComponent do
  @moduledoc false
  use HomeHubWeb, :live_component
  require Logger
  alias HomeHub.Homebridge

  @impl true
  def render(assigns) do
    ~H"""
    <button
        class="rounded-full bg-blue-800 font-bold text-2xl border-blue-800 py-2 px-8 m-4"
        phx-click="press"
        phx-target={@myself}
        value={@switch.name}>
      <%= @switch.name %>
    </button>
    """
  end

  @impl true
  def handle_event("press", %{"value" => button_name}, socket) do
    Logger.debug("#{button_name} button pressed")

    case Homebridge.Switches.press(button_name) do
      {:error, error} -> Logger.error("error pressing button #{inspect(error)}")
      _ -> :ok
    end

    {:noreply, socket}
  end
end
