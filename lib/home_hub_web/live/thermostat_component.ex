defmodule HomeHubWeb.ThermostatComponent do
  @moduledoc false
  use HomeHubWeb, :live_component

  @adjustment_amount 0.5

  @impl true
  def handle_event("furnace_toggle", _, socket) do
    if socket.assigns.status.heating do
      HomeHub.Thermostat.stop_heat()
    else
      HomeHub.Thermostat.start_heat()
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("target_down", _, socket) do
    HomeHub.Thermostat.adjust_target_by(-@adjustment_amount)
    {:noreply, socket}
  end

  @impl true
  def handle_event("target_up", _, socket) do
    HomeHub.Thermostat.adjust_target_by(@adjustment_amount)
    {:noreply, socket}
  end

  def toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:phx_click, fn -> "" end)
      |> assign_new(:phx_target, fn -> nil end)

    ~H"""
    <div class="px-4 py-2" phx-click={@phx_click} phx-target={@phx_target}>
      <%= if @on do %>
        <img class="icon icon-on-orange" src={Routes.static_path(HomeHubWeb.Endpoint, "/images/icons/toggle-on.svg")}>
      <% else %>
        <img class="icon icon-action" src={Routes.static_path(HomeHubWeb.Endpoint, "/images/icons/toggle-off.svg")}>
      <% end %>
    </div>

    <div class="px-4 py-2 text-4xl" phx-click={@phx_click} phx-target={@phx_target}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:on, fn -> false end)
      |> assign_new(:on_colour, fn -> "" end)
      |> assign_new(:off_colour, fn -> "icon-on-gray" end)
      |> assign_new(:phx_click, fn -> nil end)
      |> assign_new(:phx_target, fn -> nil end)

    ~H"""
    <div
      class="px-4 py-2"
      phx-click={@phx_click}
      phx-target={@phx_target}>
      <img class={"icon #{if assigns.on, do: assigns.on_colour, else: assigns.off_colour}"} src={@src} />
    </div>
    """
  end
end
