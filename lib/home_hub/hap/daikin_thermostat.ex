defmodule HomeHub.HAP.DaikinThermostat do
  @moduledoc """
  Maps the Daikin Thermostat to a HAP thermostat, requires a seperate
  running GenServer that caches current state.
  """
  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  alias HomeHub.Thermostat.Daikin

  @name __MODULE__

  def start_link(config), do: GenServer.start_link(@name, config, name: @name)

  @impl GenServer
  def init(_) do
    HomeHub.SensorsPubSub.subscribe(:thermostat_changes)
    {:ok, %{change_tokens: %{}}}
  end

  def hap_accessory_definition,
    do: %HAP.Accessory{name: "DaikinOne Thermostat", services: [hap_service_definition()]}

  def hap_service_definition do
    %HAP.Services.Thermostat{
      name: "DaikinOne Thermostat",
      current_state: {@name, :current_state},
      current_temp: {@name, :current_temp},
      current_humidity: {@name, :current_humidity},
      target_state: {@name, :target_state},
      target_temp: {@name, :target_temp},
      temp_display_units: {@name, :temp_display_units}
    }
  end

  def state, do: Daikin.device_info()

  @impl HAP.ValueStore
  def get_value(:active), do: {:ok, 1}
  def get_value(:current_temp), do: {:ok, Float.round(state().temp_indoor * 1.0, 1)}
  def get_value(:current_humidity), do: {:ok, Float.round(state().hum_indoor * 1.0, 0)}

  # 0 Off
  # 1 Heating
  # 2 Cooling
  # 3 Auto
  def get_value(:current_state) do
    case state().equipment_status do
      :idle -> {:ok, 0}
      :heat -> {:ok, 1}
      :cool -> {:ok, 2}
      :overcool -> {:ok, 2}
      :fan -> {:ok, 0}
    end
  end

  # 0 Off
  # 1 Heat (if current temperature is below the target temperature then turn on heating)
  # 2 Cooling (if current temperature is above the target temperature then turn on cooling)
  # 3 Auto (turn on heating or cooling to maintain temperature within the target temperatures)
  def get_value(:target_state) do
    case state().mode do
      :off -> {:ok, 0}
      :heat -> {:ok, 1}
      :cool -> {:ok, 2}
      :auto -> {:ok, 3}
    end
  end

  def get_value(:temp_display_units), do: {:ok, 0}

  def get_value(:target_temp) do
    state = state()

    case state.mode do
      :cool -> {:ok, Float.round(state.cool_setpoint * 1.0, 1)}
      _ -> {:ok, Float.round(state.heat_setpoint * 1.0, 1)}
    end
  end

  def get_value(opts) do
    Logger.error("illegal get_value #{inspect(opts)}")
    :ok
  end

  def get_value(value, name) do
    Logger.error("illegal put_value #{inspect(value)}, #{inspect(name)}")
    :ok
  end

  @impl HAP.ValueStore
  def put_value(value, :target_state) do
    value =
      case value do
        0 -> :off
        1 -> :heat
        2 -> :cool
        3 -> :auto
      end

    Daikin.set_mode(value)
    :ok
  end

  def put_value(value, :target_temp) do
    Daikin.set_target(value)
    :ok
  end

  def put_value(value, any) do
    Logger.error("caught unhandled put_value, #{inspect(any)} : #{inspect(value)}")
    :ok
  end

  @impl HAP.ValueStore
  def set_change_token(change_token, event),
    do: GenServer.call(@name, {:set_change_token, change_token, event})

  ### Thermostat Pubsub callbacks
  @impl true
  def handle_info({:thermostat_changes, changes}, state) do
    Enum.each(changes, fn
      {:temp_indoor, _val} -> fire_value_changed(state, :current_temp)
      {:hum_indoor, _val} -> fire_value_changed(state, :current_humidity)
      {:equipment_status, _val} -> fire_value_changed(state, :current_state)
      {:mode, _val} -> fire_value_changed(state, :target_state)
      {:heat_setpoint, _val} -> fire_value_changed(state, :target_temp)
      {:cool_setpoint, _val} -> fire_value_changed(state, :target_temp)
      other -> Logger.debug("Unhandled change #{inspect(other)}")
    end)

    {:noreply, state}
  end

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
