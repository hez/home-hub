defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import HomeHubWeb.HAPButtonComponents
  import HomeHubWeb.AppComponents
  import ExThermostatWeb.LiveComponent, only: [temperature_display: 1]

  alias HomeAssistant.MQTTDevice
  alias HomeHubWeb.Layouts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_show_heater_cooler(socket)}
  end

  @impl true
  def handle_event("hap_press", params, socket) do
    MQTTDevice.Button.fire("action#{params["event"]}")
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

  # Tortoise311 callbacks
  @impl true
  def handle_info({{Tortoise311, _id}, _, _ok}, socket), do: {:noreply, socket}

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
