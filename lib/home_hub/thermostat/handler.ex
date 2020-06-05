defmodule HomeHub.Thermostat.Handler do
  use GenServer

  require Logger

  alias HomeHub.Thermostat.Status

  @name __MODULE__

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        heater_io: Keyword.get(opts, :heater_io),
        fan_io: Keyword.get(opts, :fan_io)
      },
      name: @name
    )
  end

  @spec update(%Status{}) :: any()
  def update(status), do: GenServer.cast(@name, {:update, status})

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_cast({:update, status}, state) do
    state
    |> handle_heat(status)
    |> handle_fan(status)

    {:noreply, state}
  end

  @spec handle_heat(map(), %Status{}) :: map()
  defp handle_heat(state, %Status{heater_on: heating}) do
    state.heater_io.update(heating)
    state
  end

  @spec handle_fan(map(), %HomeHub.Thermostat.Status{}) :: map()
  defp handle_fan(state, %Status{fan_on: fan}) do
    state.fan_io.update(fan)
    state
  end
end
