defmodule HomeHub.SensorsServer do
  @moduledoc """
  """
  use GenServer

  @name __MODULE__

  def start_link(_opts), do: GenServer.start_link(@name, %{sensors: %{}}, name: @name)

  def all, do: GenServer.call(@name, :sensors)
  def find(name), do: all()[name]
  def set(name, value), do: GenServer.cast(@name, {:set, name, value})

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:sensors, _from, state), do: {:reply, state.sensors, state}

  @impl true
  def handle_cast({:set, name, value}, state) do
    new_values = Map.put(state.sensors, name, value)
    HomeHub.SensorsPubSub.broadcast(:sensor_status, {:sensor_status, new_values})
    {:noreply, %{state | sensors: new_values}}
  end
end
