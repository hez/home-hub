defmodule HomeHubWeb.ThermostatStatus do
  import Phoenix.LiveView
  use Phoenix.Component
  alias HomeHub.Thermostat

  def on_mount(:default, _params, _session, socket) do
    if connected?(socket) do
      Thermostat.PubSub.subscribe(:thermostat_status)
    end

    {:cont, assign(socket, status: Thermostat.status())}
  end

  ### Thermostat Pubsub callbacks
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}
end
