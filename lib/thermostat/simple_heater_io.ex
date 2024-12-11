defmodule Thermostat.SimpleHeaterIO do
  @moduledoc """
  Simple single pin to control heat.
  """
  use GenServer
  require Logger
  alias Thermostat.IO

  @name __MODULE__

  def start_link(opts) do
    {:ok, heater} = opts |> Keyword.fetch!(:heater_pin) |> IO.open_circuit()
    GenServer.start_link(@name, %{heater_circuit: heater}, name: @name)
  end

  @impl true
  def init(state) do
    Thermostat.PubSub.subscribe(:heater)
    {:ok, state}
  end

  @impl true
  def handle_info({:heater, val}, state) do
    Logger.debug("Turning heater to new value #{inspect(val)}")
    IO.write(state.heater_circuit, val)
    {:noreply, state}
  end
end
