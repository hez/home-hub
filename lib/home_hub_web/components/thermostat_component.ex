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

  attr :status, :map, required: false

  def render(assigns) do
    ~H"""
    <div class="component flex flex-row mx-2">
      <.toggle on={@status.heating} phx_click="furnace_toggle" phx_target={@myself}>
        Furnace
      </.toggle>

      <div class="px-4 py-2">
        <.fire_icon fill={if @status.heater_on, do: "fill-red-600", else: "fill-gray-500"} />
      </div>

      <div class="px-4 py-2">
        <.fan_icon fill={if @status.fan_on, do: "fill-blue-600", else: "fill-gray-500"} />
      </div>

      <%= if @status.heating do %>
        <div class="px-4 py-2" phx-click="target_down" phx-target={@myself}>
          <.caret_down_filled_icon fill="fill-blue-600" />
        </div>

        <div class={"px-4 py-2 text-4xl#{if @status.target > @status.temperature, do: " text-red-600"}"}>
          <%= @status.target %>&#176;C
        </div>

        <div class="px-4 py-2" phx-click="target_up" phx-target={@myself}>
          <.caret_up_filled_icon fill="fill-blue-600" />
        </div>
      <% end %>
    </div>
    """
  end
end
