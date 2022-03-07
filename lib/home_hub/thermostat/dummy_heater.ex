defmodule HomeHub.Thermostat.DummyHeater do
  @moduledoc false
  use GenServer
  require Logger

  @name __MODULE__

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: @name)

  @impl true
  def init(_opts), do: {:ok, nil}

  @impl true
  def handle_info({key, val}, state) do
    Logger.debug("Turning #{key} to new value #{inspect(val)}")
    {:noreply, state}
  end
end
