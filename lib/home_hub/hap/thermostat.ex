defmodule HomeHub.HAP.Thermostat do
  @moduledoc """
  Responsible for representing a HAP thermostat
  """
  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  def start_link(config),
    do: GenServer.start_link(__MODULE__, config, name: __MODULE__)

  @impl GenServer
  def init(_) do
    ExThermostat.PubSub.subscribe(:thermostat)
    {:ok, %{change_tokens: %{}}}
  end

  @impl HAP.ValueStore
  def get_value(:active), do: {:ok, 1}
  def get_value(:current_temp), do: {:ok, Float.round(ExThermostat.status().temperature, 1)}
  def get_value(:current_humidity), do: {:ok, Float.round(ExThermostat.status().humidity, 0)}

  # 0 Off
  # 1 Heating
  # 2 Cooling
  def get_value(:current_state),
    do: if(ExThermostat.status().heating, do: {:ok, 1}, else: {:ok, 0})

  # 0 Off
  # 1 Heat (if current temperature is below the target temperature then turn on heating)
  # 2 Cooling (if current temperature is above the target temperature then turn on cooling)
  # 3 Auto (turn on heating or cooling to maintain temperature within the target temperatures)
  def get_value(:target_state),
    do: if(ExThermostat.status().heating, do: {:ok, 1}, else: {:ok, 0})

  def get_value(:temp_display_units), do: {:ok, 0}

  def get_value(:target_temp), do: {:ok, Float.round(ExThermostat.status().target, 1)}

  def get_value(opts) do
    Logger.error("illegal get_value #{inspect(opts)}")
    :ok
  end

  @impl HAP.ValueStore
  def put_value(1, :target_state) do
    ExThermostat.start_heat()
    :ok
  end

  def put_value(0, :target_state) do
    ExThermostat.stop_heat()
    :ok
  end

  def put_value(value, :target_temp) do
    ExThermostat.set_target(value)
    :ok
  end

  def put_value(value, any) do
    Logger.error("caught unhandled put_value, #{inspect(any)} : #{inspect(value)}")
    :ok
  end

  def get_value(value, name) do
    Logger.error("illegal put_value #{inspect(value)}, #{inspect(name)}")
    :ok
  end

  @impl HAP.ValueStore
  def set_change_token(change_token, event),
    do: GenServer.call(__MODULE__, {:set_change_token, change_token, event})

  ### Thermostat Pubsub callbacks
  @impl true
  def handle_info({:heating, _}, state) do
    Logger.debug("Firing off HAP.value_changed from :heating")
    fire_value_changed(state, :target_state)
    {:noreply, state}
  end

  @impl true
  def handle_info({:target, _}, state) do
    Logger.debug("Firing off HAP.value_changed from :target")
    fire_value_changed(state, :target_temp)
    {:noreply, state}
  end

  @impl true
  def handle_info({:temperature, _}, state) do
    Logger.debug("Firing off HAP.value_changed from :temperature")
    fire_value_changed(state, :current_temp)
    {:noreply, state}
  end

  @impl true
  def handle_info({:humidity, _}, state) do
    Logger.debug("Firing off HAP.value_changed from :humidity")
    fire_value_changed(state, :current_humidity)
    {:noreply, state}
  end

  @impl true
  def handle_info({:thermostat, _}, state), do: {:noreply, state}

  ### Genserver callbacks
  @impl GenServer
  def handle_call({:set_change_token, change_token, event}, _from, state) do
    Logger.debug("new change token for #{inspect(event)} #{inspect(change_token)}")
    {:reply, :ok, %{state | change_tokens: Map.put(state.change_tokens, event, change_token)}}
  end

  defp fire_value_changed(%{change_tokens: tokens}, event) do
    case Map.get(tokens, event) do
      nil ->
        Logger.debug("Not firing #{inspect(event)} token not in #{inspect(tokens)}")

      token ->
        HAP.value_changed(token)
    end

    :ok
  end
end
