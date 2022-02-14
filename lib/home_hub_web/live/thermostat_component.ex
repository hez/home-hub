defmodule HomeHubWeb.ThermostatComponent do
  use HomeHubWeb, :live_component

  @impl true
  def handle_event("furnace_toggle", _, socket) do
    if socket.assigns.status.heating do
      HomeHub.Thermostat.stop_heat()
    else
      HomeHub.Thermostat.start_heat()
    end
    updated_thermostat()
    {:noreply, socket}
  end

  @impl true
  def handle_event("target_down", _, socket) do
    HomeHub.Thermostat.adjust_target_by(-0.5)
    updated_thermostat()
    {:noreply, socket}
  end

  @impl true
  def handle_event("target_up", _, socket) do
    HomeHub.Thermostat.adjust_target_by(0.5)
    updated_thermostat()
    {:noreply, socket}
  end

  defp updated_thermostat, do: send(self(), :refresh)
end
