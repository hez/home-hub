defmodule HomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    hap_config = Application.get_env(:home_hub, :hap_config)

    daikin =
      if hap_config[:hap_thermostat_module] == HomeHub.HAP.DaikinThermostat do
        [
          {HomeHub.Daikin.Supervisor,
           location_name: "Shearwater",
           update_hook: {HomeHub.Daikin.CallBackHandler, :update_hook}}
        ]
      else
        []
      end

    children =
      [
        HomeHubWeb.Telemetry,
        HomeHub.Repo,
        Supervisor.child_spec({Phoenix.PubSub, name: HomeHub.SensorsPubSub}, id: :sensors_pub_sub),
        {Phoenix.PubSub, name: HomeHub.PubSub},
        {Finch, name: HomeHub.Finch},
        HomeHubWeb.Endpoint,
        HomeHub.Phoscon.Supervisor,
        HomeHub.Reporter,
        {HomeHub.HAP.Supervisor, hap_config}
      ] ++ daikin ++ prod_children()

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
