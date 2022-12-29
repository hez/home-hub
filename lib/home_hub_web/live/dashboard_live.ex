defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  ### Thermostat Pubsub callbacks
  @impl true
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}

  ### Phoscon Pubsub callbacks
  @impl true
  def handle_info({:sensor_status, status}, socket),
    do: {:noreply, assign(socket, sensors: status)}
end
