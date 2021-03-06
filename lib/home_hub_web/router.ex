defmodule HomeHubWeb.Router do
  use HomeHubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HomeHubWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomeHubWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/current", CurrentLive, :index
    live "/history", HistoryLive, :index
  end

  scope "/", HomeHubWeb do
    pipe_through :api

    get "/status", API.HomebrigeThermostatController, :status

    get "/targetHeatingCoolingState/:target",
        API.HomebrigeThermostatController,
        :heating_cooling_state

    get "/targetTemperature/:target", API.HomebrigeThermostatController, :target_temperature
    get "/targetRelativeHumidity/:target", API.HomebrigeThermostatController, :target_humidity
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeHubWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # credo:disable-for-next-line
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HomeHubWeb.Telemetry
    end
  end
end
