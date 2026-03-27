defmodule HomeHubWeb.ThermostatHandler do
  @moduledoc """
  Handles pushing the current thermostat status to the socket on mount for the
  ThermostatWeb.StatusHandler component, which is used by the ThermostatWeb.LiveComponent
  and the DashboardLive to display the current thermostat status on page load.
  """
  use Phoenix.Component
  require Logger

  def on_mount(_, _params, _session, socket) do
    Logger.debug("Mounting ThermostatHandler")
    {:cont, assign_new(socket, :thermostat, fn -> HomeHub.Thermostat.Homex.status() end)}
  end
end
