defmodule HomeHub.Phoscon.Server do
  @moduledoc """
  """

  use GenServer
  require Logger
  alias HomeHub.Phoscon

  @name __MODULE__
  @poll_interval 30 * 1000

  def start_link(_opts),
    do: GenServer.start_link(@name, %{sensors: %{}}, name: @name)

  def all, do: GenServer.call(@name, :sensors)
  def find(name), do: all()[name]

  @impl true
  def init(state) do
    queue_poll()
    {:ok, state, {:continue, :init_sensors}}
  end

  @impl GenServer
  def handle_continue(:init_sensors, state) do
    {:noreply, %{state | sensors: fetch_sensors()}}
  end

  @impl true
  def handle_call(:sensors, _from, state), do: {:reply, state.sensors, state}

  @impl true
  def handle_info(:poll, state) do
    new_values = fetch_sensors()
    HomeHub.SensorsPubSub.broadcast(:sensor_status, {:sensor_status, new_values})
    queue_poll()
    {:noreply, %{state | sensors: new_values}}
  end

  def fetch_sensors, do: Phoscon.fetch_all()

  defp queue_poll, do: Process.send_after(self(), :poll, @poll_interval)
end
