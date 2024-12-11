defmodule HomeHub.Reporter do
  @moduledoc """
  Subscribes to the temperature updates and pushes them up to the InfluxDB.
  """

  use GenServer
  require Logger

  alias HomeHub.ReportingConnection

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

    if ReportingConnection.configured?() do
      ReportingConnection.insert(vals)
    else
      Logger.info("Not reporting data, reporting connection not configured")
    end

    {:noreply, state}
  end
end
