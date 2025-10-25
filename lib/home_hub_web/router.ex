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

    get "/page", PageController, :home

    live_session :default,
      on_mount: [
        HomeHubWeb.Nav,
        {ExThermostatWeb.StatusComponent,
         [thermostat_implementation: HomeHub.thermostat_implementation()]},
        HomeHubWeb.SensorStatus
      ] do
      live "/", DashboardLive
      live "/sensors", SensorsLive
      live "/settings", SettingsLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeHubWeb do
  #   pipe_through :api
  # end
end
