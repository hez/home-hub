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
  def render(assigns) do
    ~H"""
    <Layouts.dashboard flash={@flash} nav={@nav} sensors={@sensors}>
      <section class="container">
        <div class="flex justify-between m-4">
          <div class="text-4xl flex">
            <div><.tree_icon class="h-10 w-10 mr-4 fill-green-600" /></div>
            <.temperature_display sensor={@sensors[@outside_sensor]} />
          </div>

          <div class="text-4xl flex">
            <div>
              <.icon name="hero-home-solid" class="h-10 w-10 mr-4 text-amber-600" />
            </div>
            <.temperature_display sensor={@thermostat} />
          </div>
        </div>
      </section>

      <.live_component
        module={ThermostatWeb.LiveComponent}
        thermostat={@thermostat}
        id={:heater_thermostat}
        show_cooler={@show_cooler}
        show_heater={@show_heater}
        class="justify-evenly"
      />

      <div class="pt-10 flex py-6 justify-center"></div>
    </Layouts.dashboard>
    """
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
