defmodule HomeHubWeb.Router do
  use HomeHubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HomeHubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HomeHubWeb do
    pipe_through :api

    scope "/homebridge" do
      get "/status", HomebridgeController, :status
      get "/targetHeatingCoolingState/:target", HomebridgeController, :heating_cooling_state
      get "/targetTemperature/:target", HomebridgeController, :target_temperature
      get "/targetRelativeHumidity/:target", HomebridgeController, :target_humidity
    end
  end

  scope "/", HomeHubWeb do
    pipe_through :browser

    live_session :default,
      on_mount: [HomeHubWeb.Nav, HomeHubWeb.ThermostatStatus, HomeHubWeb.SensorStatus] do
      live "/", DashboardLive
      live "/current", CurrentLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeHubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:home_hub, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HomeHubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
