defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import ExThermostatWeb.LiveComponent, only: [temperature_display: 1]
  import HomeHubWeb.AppComponents

  alias HomeHubWeb.Layouts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_show_heater_cooler() |> assign(outside_sensor: "furnace outdoor")}
  end

  @impl true
  def handle_event(event, _params, socket) do
    Logger.debug("Got unhandled event: #{inspect(event)}")
    {:noreply, socket}
  end

  @impl true
  ### Thermostat Pubsub callbacks
  def handle_info(%ExThermostat.Status{} = status, socket),
    do: {:noreply, socket |> assign(status: status) |> assign_show_heater_cooler()}

  def handle_info(_, socket), do: {:noreply, socket}

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
