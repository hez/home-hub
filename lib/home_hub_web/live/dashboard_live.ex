defmodule HomeHubWeb.DashboardLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import ThermostatWeb.LiveComponent, only: [temperature_display: 1]
  import HomeHubWeb.AppComponents

  alias HomeHubWeb.Layouts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(outside_sensor: "furnace outdoor")}
  end

  @impl true
  def handle_event(event, _params, socket) do
    Logger.debug("Got unhandled event: #{inspect(event)}")
    {:noreply, socket}
  end

  @impl true
  def handle_info(_event, socket) do
    {:noreply, socket}
  end
end
