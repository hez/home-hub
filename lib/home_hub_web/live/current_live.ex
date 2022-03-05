defmodule HomeHubWeb.CurrentLive do
  @moduledoc false
  use HomeHubWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_status(socket)}
  end

  defp assign_status(socket), do: assign(socket, status: HomeHub.Thermostat.status())
end
