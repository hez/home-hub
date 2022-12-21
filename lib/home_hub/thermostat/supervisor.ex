defmodule HomeHub.Thermostat.Supervisor do
  @moduledoc false
  use Supervisor
  alias HomeHub.Thermostat

  @name __MODULE__

  @default_pid_settings [
    # setpoint: 0.0,
    kp: 0.2,
    ki: 0.1,
    # kd: 0.0
    # action: :direct,
    output_limits: {-5.0, 5.0}
  ]

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children = [
      {Phoenix.PubSub, name: HomeHub.Thermostat.PubSub},
      {Thermostat.PID, Keyword.get(opts, :pid_settings, @default_pid_settings)},
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
