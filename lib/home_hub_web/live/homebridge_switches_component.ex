defmodule HomeHubWeb.HomebridgeSwitchesComponent do
  @moduledoc false
  use HomeHubWeb, :live_component
  require Logger
  alias HomeHub.Homebridge

  @impl true
  def render(assigns) do
    ~H"""
    <div class="component flex flex-row m-8">
      <%= for {_name, switch} <- @switches do %>
        <.button phx_click="press" phx_target={@myself} label={switch.name} />
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("press", %{"value" => button_name}, socket) do
    Logger.debug("#{button_name} button pressed")

    case Homebridge.Switches.press(button_name) do
      {:error, error} -> Logger.error("error pressing '#{button_name}' button #{inspect(error)}")
      _ -> :ok
    end

    {:noreply, socket}
  end
end
