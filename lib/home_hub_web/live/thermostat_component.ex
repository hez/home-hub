defmodule HomeHubWeb.ThermostatComponent do
  use Phoenix.LiveComponent

  @impl true
  def handle_event("furnace_on", _, socket) do
    HomeHub.Thermostat.start_heat()
    updated_thermostat()
    {:noreply, socket}
  end

  @impl true
  def handle_event("furnace_off", _, socket) do
    HomeHub.Thermostat.stop_heat()
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
