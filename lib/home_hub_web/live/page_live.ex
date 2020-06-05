defmodule HomeHubWeb.PageLive do
  use HomeHubWeb, :live_view
  require Logger
  @refresh_interval 5_000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(@refresh_interval, self(), :refresh)
    end

    {:ok, assign_status(socket)}
  end

  @impl true
  def handle_info(:refresh, socket), do: {:noreply, assign_status(socket)}

  defp assign_status(socket) do
    socket
    |> assign(status: HomeHub.Thermostat.status())
    |> assign(lights: HomeHub.Lights.all())
    |> assign(switches: HomeHub.Switches.all())
  end
end
