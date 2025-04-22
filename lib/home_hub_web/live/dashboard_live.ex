defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import HomeHubWeb.HAPButtonComponents

  alias HomeHub.HAP.StatelessSwitch

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_show_heater_cooler(socket)}
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
  def handle_info(%ExThermostat.Status{} = status, socket),
    do: {:noreply, socket |> assign(status: status) |> assign_show_heater_cooler()}

  ### Phoscon Pubsub callbacks
  @impl true
  def handle_info({:sensor_status, status}, socket),
    do: {:noreply, assign(socket, sensors: status)}

  def assign_show_heater_cooler(%{assigns: %{status: status}} = socket) do
    {show_heater, show_cooler} =
      cond do
        status.mode == :heat -> {true, false}
        status.mode == :cool -> {false, true}
        true -> {true, true}
      end

    socket
    |> assign(:show_heater, show_heater)
    |> assign(:show_cooler, show_cooler)
  end
end
