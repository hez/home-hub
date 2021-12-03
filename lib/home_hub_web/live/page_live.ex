defmodule HomeHubWeb.PageLive do
  use HomeHubWeb, :live_view
  alias HomeHub.Thermostat
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Thermostat.PubSub.subscribe(:thermostat)
    end

    {:ok, assign_status(socket)}
  end

  @impl true
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}

  @impl true
  def handle_info(:refresh, socket), do: {:noreply, assign_status(socket)}

  defp assign_status(socket) do
    assign(socket, status: Thermostat.status())
  end
end
