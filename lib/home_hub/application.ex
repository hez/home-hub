defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HomeHub.Repo,
      # Start the Telemetry supervisor
      HomeHubWeb.Telemetry,
      HomeHub.Thermostat.Supervisor,
      # Start the PubSub system
      {Phoenix.PubSub, name: HomeHub.PubSub},
      # Start the Endpoint (http/https)
      HomeHubWeb.Endpoint,
      # Start a worker by calling: HomeHub.Worker.start_link(arg)
      # {HomeHub.Worker, arg}
      HomeHub.ReportingConnection
    ]

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
end
