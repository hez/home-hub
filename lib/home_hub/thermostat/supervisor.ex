defmodule HomeHub.Thermostat.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger
  alias HomeHub.Thermostat

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children =
      [
        {Phoenix.PubSub, name: Thermostat.PubSub},
        temp_sensor_impl(opts),
        io_impl(opts),
        {Thermostat.PID, Keyword.get(opts, :pid_settings, [])},
        {Thermostat, Keyword.get(opts, :settings, [])}
      ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  if Mix.env() == :test or Mix.env() == :dev do
    defp io_impl(_), do: {Thermostat.DummyHeater, []}
    defp temp_sensor_impl(_), do: {Thermostat.DummyTempSensor, []}
  else
    defp io_impl(opts) do
      case Keyword.get(opts, :io_config) do
        nil -> raise "Failed to get io_config"
        values -> {Thermostat.IO, values}
      end
    end

    defp temp_sensor_impl(opts) do
      case Keyword.get(opts, :io_config) do
        nil -> raise "Failed to get io_config"
        values -> {Thermostat.TemperatureSensor, values}
      end
    end
  end
end
