defmodule HomeHub.HAP.DevThermostat do
  @moduledoc """
  A development ver of the HAP Thermostat
  """
  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  @name __MODULE__

  @initial_state %{
    active: 1,
    current_temp: 16.0,
    current_humidity: 55.0,
    current_state: 1,
    target_state: 1,
    target_temp: 18.0
  }

  def start_link(config),
    do: GenServer.start_link(@name, config, name: @name)

  def hap_accessory_definition do
    %HAP.Accessory{
      name: "Thermostat dev",
      services: [
        %HAP.Services.Thermostat{
          name: "Thermostat dev",
          current_state: {@name, :current_state},
          current_temp: {@name, :current_temp},
          current_humidity: {@name, :current_humidity},
          target_state: {@name, :target_state},
          target_temp: {@name, :target_temp},
          temp_display_units: {@name, :temp_display_units}
        }
      ]
    }
  end

  @impl GenServer
  def init(_) do
    state =
      if HomeHub.winter_mode?(Date.utc_today()),
        do: %{@initial_state | target_state: 1, target_temp: 16.0},
        else: @initial_state

    {:ok, %{change_tokens: %{}, state: state}}
  end

  def state, do: GenServer.call(@name, :state)
  def update_state(key, value), do: GenServer.cast(@name, {:update_state, key, value})

  @impl HAP.ValueStore
  def get_value(:active), do: {:ok, state().active}
  def get_value(:current_temp), do: {:ok, state().current_temp}
  def get_value(:current_humidity), do: {:ok, state().current_humidity}

  # 0 Off
  # 1 Heating
  # 2 Cooling
  def get_value(:current_state), do: {:ok, state().current_state}

  # 0 Off
  # 1 Heat (if current temperature is below the target temperature then turn on heating)
  # 2 Cooling (if current temperature is above the target temperature then turn on cooling)
  # 3 Auto (turn on heating or cooling to maintain temperature within the target temperatures)
  def get_value(:target_state), do: {:ok, state().target_state}

  def get_value(:temp_display_units), do: {:ok, 0}

  def get_value(:target_temp), do: {:ok, state().target_temp}

  def get_value(opts) do
    Logger.error("illegal get_value #{inspect(opts)}")
    :ok
  end

  @impl HAP.ValueStore
  def put_value(value, :target_state) do
    update_state(:target_state, value)
    :ok
  end

  def put_value(value, :target_temp) do
    update_state(:target_temp, value)
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

  @impl GenServer
  def handle_cast({:update_state, key, value}, state) do
    Logger.info("new state #{inspect(key)} #{inspect(value)}")
    fire_value_changed(state, key)
    {:noreply, %{state | state: Map.put(state.state, key, value)}}
  end

  ### Genserver callbacks
  @impl GenServer
  def handle_call(:state, _from, state), do: {:reply, state.state, state}

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
