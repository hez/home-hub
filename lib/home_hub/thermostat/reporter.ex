defmodule HomeHub.Thermostat.Reporter do
  @moduledoc """
  Subscribes to the temperature updates and pushes them up to the InfluxDB.
  """

  use GenServer
  alias HomeHub.Thermostat
  require Logger

  @name __MODULE__

  def start_link(_opts), do: GenServer.start_link(@name, nil, name: @name)

  @impl true
  def init(state) do
    Logger.debug("Starting")
    Thermostat.PubSub.subscribe(:temperature)
    {:ok, state}
  end

  @impl true
  def handle_info(%{temperature: _, humidity: _} = vals, state) do
    Logger.debug("got new temp and hum, #{inspect(vals)}")
    HomeHub.ReportingConnection.insert(vals)
    {:noreply, state}
  end
end
