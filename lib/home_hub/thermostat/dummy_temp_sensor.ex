if Mix.env() == :test or Mix.env() == :dev do
  defmodule HomeHub.Thermostat.DummyTempSensor do
    @moduledoc false
    use GenServer
    alias HomeHub.Thermostat

    @poll_interval 10_000
    @name __MODULE__

    def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: @name)

    @impl true
    def init(_opts) do
      queue_poll()
      {:ok, %{temperature: 15.0, humidity: 50.0}}
    end

    @impl true
    def handle_info(:poll, state) do
      queue_poll()

      new_t =
        case HomeHub.Thermostat.status().heater_on do
          true -> state.temperature + :rand.uniform(2) / 10
          false -> state.temperature - :rand.uniform(2) / 10
        end

      new_h =
        case :rand.uniform() > 0.5 do
          true -> state.humidity - :rand.uniform(20) / 10
          false -> state.humidity + :rand.uniform(20) / 10
        end

      Thermostat.PubSub.broadcast(:temperature, %{temperature: new_t, humidity: new_h})

      {:noreply, %{state | temperature: new_t, humidity: new_h}}
    end

    defp queue_poll, do: Process.send_after(self(), :poll, @poll_interval)
  end
end
