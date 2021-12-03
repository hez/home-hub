defmodule HomeHub.Thermostat.Supervisor do
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

  @temp_sensor_impl Application.compile_env!(:home_hub, :temperature_sensor_implementation)

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(_opts) do
    children = [
      {Phoenix.PubSub, name: HomeHub.Thermostat.PubSub},
      {Pidex.PdxServer, settings: @pid_settings, ts_unit: :millisecond},
      @temp_sensor_impl,
      HomeHub.Thermostat
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
