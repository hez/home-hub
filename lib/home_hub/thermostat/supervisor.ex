defmodule HomeHub.Thermostat.Supervisor do
  @moduledoc false
  use Supervisor

  @name __MODULE__

  @pid_settings %Pidex{
    kP: 1.1,
    kI: 1.0,
    kD: 0.001,
    min_point: -25.0,
    max_point: 10.0,
    ts_factor: 30_000.0
  }

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children = [
      {Phoenix.PubSub, name: HomeHub.Thermostat.PubSub},
      {Pidex.PdxServer, settings: @pid_settings, ts_unit: :millisecond},
      temp_sensor_impl(opts),
      heater_io_impl(opts),
      HomeHub.Thermostat,
      HomeHub.Thermostat.Reporter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  if Mix.env() == :test or Mix.env() == :dev do
    defp heater_io_impl(_), do: {HomeHub.Thermostat.DummyHeater, []}
    defp temp_sensor_impl(_), do: {HomeHub.Thermostat.DummyTempSensor, []}
  else
    defp heater_io_impl(opts) do
      case Keyword.get(opts, :heater_io_config) do
        nil -> raise "Failed to get heater_io_config"
        values -> {HomeHub.Thermostat.HeaterIO, values}
      end
    end

    defp temp_sensor_impl(opts) do
      case Keyword.get(opts, :heater_io_config) do
        nil -> raise "Failed to get heater_io_config"
        values -> {HomeHub.Thermostat.TemperatureSensor, values}
      end
    end
  end
end
