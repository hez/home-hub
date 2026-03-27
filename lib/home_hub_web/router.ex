defmodule HomeHubWeb.Router do
  use HomeHubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HomeHubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomeHubWeb do
    pipe_through :browser

    live_session :default,
      on_mount: [
        HomeHubWeb.Nav,
        HomeHubWeb.ThermostatHandler,
        ThermostatWeb.StatusHandler,
        HomeHubWeb.SensorStatusHandler,
        HomeHubWeb.InactivityHandler
      ] do
      live "/", DashboardLive
      live "/sensors", SensorsLive
      live "/scenes", ScenesLive
    end

    live "/kiosk_dashboard", DashboardLive
    live "/gpio", GPIOLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeHubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard for demonstration purposes
  #
  import Phoenix.LiveDashboard.Router

  scope "/dev" do
    pipe_through :browser

    live_dashboard "/dashboard", metrics: HomeHubWeb.Telemetry
  end
end
