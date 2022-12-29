defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  alias HomeHub.Thermostat

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Thermostat.PubSub.subscribe(:thermostat_status)
    end

    {:ok, assign_status(socket)}
  end

  @impl true
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}

  defp assign_status(socket), do: assign(socket, status: Thermostat.status())
end
