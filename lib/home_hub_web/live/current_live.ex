defmodule HomeHubWeb.CurrentLive do
  @moduledoc false
  use HomeHubWeb, :live_view
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

  defp assign_status(socket), do: assign(socket, status: Thermostat.status())

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <.live_component
        module={HomeHubWeb.GrafanaPanelComponent}
        id="temperature-panel"
        width="715"
        height="250"
        src="http://100.113.197.93:3000/d-solo/N3KOFE4nk/overview?orgId=1&panelId=23&refresh=5m"
      />
    </div>
    """
  end
end
