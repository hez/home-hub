defmodule HomeHub.Application do
  require Logger

  alias HomeHub.IO.Light
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @pid_settings %Pidex{
    kP: 1.1,
    kI: 1.0,
    kD: 0.001,
    min_point: -25.0,
    max_point: 10.0,
    ts_factor: 30_000.0
  }

  use Application

  def start(_type, _args) do
    Logger.info("Starting HomeHub!")

    children =
      [
        # Start the Telemetry supervisor
        HomeHubWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: HomeHub.PubSub},
        # Start the Endpoint (http/https)
        HomeHubWeb.Endpoint,
        {HomeHub.Lights, lights: fetch_lights()},
        {HomeHub.Switches, switches: fetch_switches()},
        {HomeHub.Thermostat.Supervisor, children: thermostat_children()},
        HomeHub.ReportingConnection,
        HomeHub.Scheduler
      ] ++ app_children()

    HomeHub.Pigpiox.Supervisor.start_link()
    PhosconAPI.EventHandler.attach()
    PhosconAPI.ButtonsTable.create!(fetch_buttons())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HomeHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HomeHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # credo:disable-for-next-line

  defp fetch_lights do
    :home_hub
    |> Application.get_env(:lights, [])
    |> Enum.map(&Kernel.struct(Light, &1))
  end

  defp fetch_switches, do: Application.get_env(:home_hub, :switches, [])

  defp fetch_buttons, do: Application.get_env(:home_hub, :buttons, [])

  defp phoscon_url, do: Application.get_env(:home_hub, :phoscon_url)

  # credo:disable-for-next-line
  if Mix.env() == :prod do
    defp app_children do
      [{RpiScreenDimmer, []}, {PhosconAPI.WebSocket, url: phoscon_url()}]
    end

    defp thermostat_children do
      [
        {Pidex.PdxServer, settings: @pid_settings, ts_unit: :millisecond},
        {HomeHub.IO.Fan, pin: Application.get_env(:home_hub, :fan_pin)},
        {HomeHub.IO.Heater, pin: Application.get_env(:home_hub, :heater_pin)},
        {HomeHub.Thermostat.Handler, heater_io: HomeHub.IO.Heater, fan_io: HomeHub.IO.Fan},
        {HomeHub.Thermostat, handler: HomeHub.Thermostat.Handler},
        {HomeHub.IO.TempProbe,
         notifies: [&HomeHub.ReportingConnection.insert/1, &HomeHub.Thermostat.update/1],
         dht_pin: Application.get_env(:home_hub, :dht_pin)}
      ]
    end
  else
    defp app_children do
      []
    end

    defp thermostat_children do
      [
        {Pidex.PdxServer, settings: @pid_settings, ts_unit: :millisecond},
        {HomeHub.Thermostat.DummyTempSensor, notifies: [&HomeHub.Thermostat.update/1]},
        HomeHub.Thermostat.DummyFanIO,
        HomeHub.Thermostat.DummyHeaterIO,
        {HomeHub.Thermostat.Handler,
         heater_io: HomeHub.Thermostat.DummyHeaterIO, fan_io: HomeHub.Thermostat.DummyFanIO},
        {HomeHub.Thermostat, handler: HomeHub.Thermostat.Handler}
      ]
    end
  end
end
