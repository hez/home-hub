defmodule HomeHubWeb.ThermostatStatus do
  import Phoenix.LiveView
  use Phoenix.Component
  alias HomeHub.Thermostat

  def on_mount(:default, _params, _session, socket) do
    if connected?(socket) do
      Thermostat.PubSub.subscribe(:thermostat)
    end

    {:cont, assign(socket, status: Thermostat.status())}
  end

  ### Thermostat Pubsub callbacks
  def handle_info({:thermostat, status}, socket), do: {:noreply, assign(socket, status: status)}
  def handle_info({:heating, _}, socket), do: {:noreply, socket}
  def handle_info({:target, _}, socket), do: {:noreply, socket}
  def handle_info({:temperature, _}, socket), do: {:noreply, socket}
  def handle_info({:humidity, _}, socket), do: {:noreply, socket}
end
