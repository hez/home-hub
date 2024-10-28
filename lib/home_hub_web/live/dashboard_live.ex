defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import HomeHubWeb.HAPButtonComponents

  alias HomeHub.HAP.StatelessSwitch

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("hap_press", params, socket) do
    StatelessSwitch.press(
      String.to_existing_atom(params["name"]),
      String.to_integer(params["event"])
    )

    {:noreply, socket}
  end

  ### Thermostat Pubsub callbacks
  @impl true
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}

  ### Phoscon Pubsub callbacks
  @impl true
  def handle_info({:sensor_status, status}, socket),
    do: {:noreply, assign(socket, sensors: status)}
end
