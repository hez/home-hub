defmodule HomeHub.Sensors do
  use GenServer
  alias HomeHub.Model

  @name __MODULE__

  def start_link(_opts), do: GenServer.start_link(@name, %{sensors: %{}}, name: @name)

  def alertable?(%{} = sensors), do: Enum.any?(sensors, &alertable?/1)
  def alertable?({_, sensor}), do: Model.TemperatureSensor.alertable?(sensor)

  def all, do: GenServer.call(@name, :sensors)
  def find(name), do: all()[name]

  def find_or_new(name) do
    all()[name] ||
      Model.TemperatureSensor.new(%{
        name: name,
        temperature: 0.0,
        humidity: 0.0,
        battery: nil,
        lastseen: DateTime.utc_now()
      })
  end

  def set(name, value), do: GenServer.cast(@name, {:set, name, value})

  @impl true
  def init(state) do
    HomeHub.SensorsPubSub.subscribe(:thermostat_sensor)
    {:ok, state}
  end

  @impl true
  def handle_call(:sensors, _from, state), do: {:reply, state.sensors, state}

  @impl true
  def handle_cast({:set, name, value}, state) do
    new_values = Map.put(state.sensors, name, value)
    HomeHub.SensorsPubSub.broadcast(:sensor_status, {:sensor_status, new_values})
    {:noreply, %{state | sensors: new_values}}
  end

  @impl true
  def handle_info(%Model.TemperatureSensor{} = sensor, state),
    do: handle_cast({:set, sensor.name, sensor}, state)
end
