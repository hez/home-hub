defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Telemetry supervisor
        HomeHubWeb.Telemetry,
        # Start the Ecto repository
        HomeHub.Repo,
        {HomeHub.Thermostat.Supervisor, Application.get_env(:home_hub, :thermostat)},
        # Start the PubSub system
        {Phoenix.PubSub, name: HomeHub.PubSub},
        # Start Finch
        {Finch, name: HomeHub.Finch},
        # Start the Endpoint (http/https)
        HomeHubWeb.Endpoint,
        # Start a worker by calling: HomeHub.Worker.start_link(arg)
        # {HomeHub.Worker, arg}
        HomeHub.HAP.Supervisor,
        HomeHub.Phoscon.Supervisor,
        HomeHub.Reporter
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

  if Mix.env() == :prod do
    def prod_children do
      [{RpiScreenDimmer, []}]
    end
  else
    def prod_children, do: []
  end
end
