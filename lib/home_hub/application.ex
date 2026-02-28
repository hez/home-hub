defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {Phoenix.PubSub, name: HomeHub.PubSub},
        Supervisor.child_spec({Phoenix.PubSub, name: HomeHub.SensorsPubSub}, id: :sensors_pub_sub),
        Supervisor.child_spec({Phoenix.PubSub, name: Homex.PubSub}, id: :homex_pub_sub),
        HomeHub.SensorsServer,
        HomeHubWeb.Telemetry,
        HomeHub.Repo,
        {Ecto.Migrator,
         repos: Application.fetch_env!(:home_hub, :ecto_repos), skip: skip_migrations?()},
        {DNSCluster, query: Application.get_env(:home_hub, :dns_cluster_query) || :ignore},
        HomeHubWeb.Endpoint,
        Homex,
        HomeHub.Thermostat.Homex,
        {Homex.WebsocketClient,
         token: Application.get_env(:home_hub, :home_assistant_access_token),
         host: Application.get_env(:home_hub, :home_assistant_host),
         port: Application.get_env(:home_hub, :home_assistant_port, 8123)}
      ] ++ prod_children()

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

  if Mix.env() == :prod do
    def prod_children do
      [
        {BacklightAutomation.Server,
         [pubsub: HomeHub.PubSub, active_level: 100, inactive_level: 30, dim_interval: 60]}
      ]
    end
  else
    def prod_children, do: []
  end
end
