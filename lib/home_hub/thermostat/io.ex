defmodule HomeHub.Thermostat.IO do
  @moduledoc """
  Interface to the GPIO pins that control the heater and fan.
  """
  use GenServer
  alias HomeHub.Thermostat
  require Logger

  @name __MODULE__

  def start_link(opts) do
    {:ok, heater} = opts |> Keyword.fetch!(:heater_pin) |> open_circuit()
    {:ok, fan} = opts |> Keyword.fetch!(:fan_pin) |> open_circuit()

    GenServer.start_link(@name, %{fan_circuit: fan, heater_circuit: heater}, name: @name)
  end

  @impl true
  def init(state) do
    Thermostat.PubSub.subscribe(:heater)
    Thermostat.PubSub.subscribe(:fan)
    {:ok, state}
  end

  @impl true
  def handle_info({:heater, val}, %{heater_circuit: heater} = state) do
    Logger.debug("Turning heater to new value #{inspect(val)}")
    write(heater, val)
    {:noreply, state}
  end

  @impl true
  def handle_info({:fan, val}, %{fan_circuit: fan} = state) do
    Logger.debug("Turning fan to new value #{inspect(val)}")
    write(fan, val)
    {:noreply, state}
  end

  def write(circuit, true), do: Circuits.GPIO.write(circuit, 1)
  def write(circuit, false), do: Circuits.GPIO.write(circuit, 0)

  defp open_circuit(pin), do: Circuits.GPIO.open(pin, :output)
end
