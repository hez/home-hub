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
end
