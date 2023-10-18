defmodule HomeHub.Thermostat.TemperatureSensor do
  @moduledoc """
  Starts the DHT service and subscribes to the DHT telemetry messages
  rebroadcasting them in to the Thermostat.PubSub.
  """
  use GenServer
  require Logger
  alias HomeHub.Thermostat

  @name __MODULE__
  @max_num_values 10
  @temp_variance 7.0
  @humid_variance 40.0
  # seconds
  @dht_poll_interval 60

  def start_link(opts) do
    pin = Keyword.get(opts, :dht_pin)
    DHT.start_polling(pin, :dht22, @dht_poll_interval)

    GenServer.start_link(__MODULE__, %{temperatures: [], humiditys: []}, name: @name)
  end

  def get, do: GenServer.call(@name, {:get})

  def set_temp([:dht, :read], measurements, _metadata, _conf) do
    measurements |> inspect() |> Logger.debug(label: :dht_read)
    state = get()

    if valid?(state, measurements) do
      GenServer.cast(@name, {:set, measurements.temperature, measurements.humidity})
      Thermostat.PubSub.broadcast(:temperature, measurements)
    else
      Logger.warning("Got invlaid measurements, throwing them away #{inspect(measurements)}")
    end
  end

  @impl GenServer
  def init(state) do
    attach()
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:get}, _, state), do: {:reply, state, state}

  @impl GenServer
  def handle_cast({:set, temp, humid}, state) do
    {
      :noreply,
      %{
        state
        | temperatures: [temp | Enum.take(state.temperatures, @max_num_values - 1)],
          humiditys: [humid | Enum.take(state.humiditys, @max_num_values - 1)]
      }
    }
  end

  defp attach do
    :ok =
      :telemetry.attach(
        "homehub-tempprob-server",
        [:dht, :read],
        &__MODULE__.set_temp/4,
        nil
      )
  end

  defp valid?(%{temperatures: [], humiditys: []}, _), do: true

  defp valid?(%{temperatures: temps, humiditys: humids}, %{
         temperature: new_temp,
         humidity: new_humid
       }) do
    avg_temp = Enum.sum(temps) / Enum.count(temps)
    avg_humid = Enum.sum(humids) / Enum.count(humids)

    new_temp > avg_temp - @temp_variance and
      new_temp < avg_temp + @temp_variance and
      new_humid > avg_humid - @humid_variance and
      new_humid < avg_humid + @humid_variance
  end
end
