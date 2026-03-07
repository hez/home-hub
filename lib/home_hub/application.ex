defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children =
      [
        {Phoenix.PubSub, name: HomeHub.PubSub},
        Supervisor.child_spec({Phoenix.PubSub, name: HomeHub.SensorsPubSub}, id: :sensors_pub_sub),
        HomeHub.SensorsServer,
        HomeHubWeb.Telemetry,
        HomeHub.Repo,
        {Ecto.Migrator,
         repos: Application.fetch_env!(:home_hub, :ecto_repos), skip: skip_migrations?()},
        {DNSCluster, query: Application.get_env(:home_hub, :dns_cluster_query) || :ignore},
        HomeHubWeb.Endpoint,
        Thermostat,
        Homex,
        HomeHub.Thermostat.Homex
      ] ++ backlight_automation() ++ homex_websocket_client()

    Logger.add_handlers(:home_hub)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HomeHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HomeHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations? do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end

  defp homex_websocket_client do
    if Application.get_env(:home_hub, :home_assistant_host) do
      [
        {Homex.WebsocketClient,
         token: Application.get_env(:home_hub, :home_assistant_access_token),
         host: Application.get_env(:home_hub, :home_assistant_host),
         port: Application.get_env(:home_hub, :home_assistant_port, 8123)}
      ]
    else
      Logger.warning("Invalid or missing Homex Websocket config, not starting client")
      []
    end
  end

  if Mix.env() != :test and Mix.env() != :dev do
    def backlight_automation,
      do: [{BacklightAutomation, [active_level: 100, inactive_level: 30, dim_interval: 60]}]
  else
    def backlight_automation, do: []
  end
end
