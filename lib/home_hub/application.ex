defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Start the Telemetry supervisor
    # Start the Ecto repository
    # Start the PubSub system
    # Start Finch
    # Start the Endpoint (http/https)
    # Start a worker by calling: HomeHub.Worker.start_link(arg)
    # {HomeHub.Worker, arg}
    thermostat_settings =
      Application.get_env(:home_hub, :thermostat) |> append_thermostat_status()

    children =
      [
        HomeHubWeb.Telemetry,
        HomeHub.Repo,
        {ExThermostat.Supervisor, thermostat_settings},
        {Phoenix.PubSub, name: HomeHub.PubSub},
        {Finch, name: HomeHub.Finch},
        HomeHubWeb.Endpoint,
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

  @spec append_thermostat_status(Keyword.t()) :: Keyword.t()
  def append_thermostat_status(options) do
    options = Keyword.put_new(options, :settings, [])

    status =
      if Keyword.get(options, :winter_mode_enabled, true) and
           winter_mode?(options, Date.utc_today()) do
        %ExThermostat.Status{
          heating: true,
          target: Keyword.get(options, :winter_target_temperature)
        }
      else
        %ExThermostat.Status{}
      end

    put_in(options, [:settings, :status], status)
  end

  @spec winter_mode?(Keyword.t(), Date.t()) :: boolean()
  def winter_mode?(options, date) do
    winter_start = %{Keyword.get(options, :winter_start) | year: date.year}
    winter_end = %{Keyword.get(options, :winter_end) | year: date.year}
    Date.compare(date, winter_start) === :gt or Date.compare(date, winter_end) === :lt
  end

  if Mix.env() == :prod do
    def prod_children do
      [{RpiScreenDimmer, []}]
    end
  else
    def prod_children, do: []
  end
end
