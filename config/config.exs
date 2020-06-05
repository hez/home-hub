# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :home_hub, :time_zone, "America/Vancouver"

# Configures the endpoint
config :home_hub, HomeHubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/p91Y6ic2Q9bBncH1BlxWtzWjUoHBFPeKWVy/j16otWwIBQ2QQ0JRKLj9miY8bzi",
  render_errors: [view: HomeHubWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HomeHub.PubSub,
  live_view: [signing_salt: "INIxByWt"]

config :home_hub, HomeHub.ReportingConnection,
  tag_host: "thermostat",
  database: "climate",
  host: System.get_env("INFLUXDB_HOST"),
  pool: [max_overflow: 10, size: 50],
  port: 8086,
  scheme: "http",
  auth: [
    method: :basic,
    username: System.get_env("INFLUXDB_USERNAME"),
    password: System.get_env("INFLUXDB_PASSWORD")
  ],
  writer: Instream.Writer.Line

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:mfa, :request_id, :label]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * *
config :home_hub, HomeHub.Scheduler,
  jobs: [
    {"0 * * * *", {HomeHub.Scheduler, :check_screen_levels, []}}
  ]

if System.get_env("VAN") == "1" do
  IO.puts("BUILDING ---> Van")

  config :home_hub, :lights, [
    [type: HomeHub.IO.DummyLight, name: :inside, title: "Inside"]
  ]

  config :home_hub, :buttons, [
    %{
      id: 26,
      handler: {HomeHub.IO.SmallButton, :handle, %{single_press: :inside, long_press: :inside}}
    }
  ]
else
  IO.puts("BUILDING ---> Thermostat")
  config :pigpiox, hostname: 'localhost'

  config :home_hub,
    dht_pin: 18,
    fan_pin: 17,
    heater_pin: 27

  config :home_hub, :switches, [
    %{
      name: "Morning",
      accessory_id: "thermostatvirtualswitch",
      button_name: "One",
      event: :single_press
    },
    %{
      name: "Bedtime",
      accessory_id: "thermostatvirtualswitch",
      button_name: "Two",
      event: :double_press
    },
    %{
      name: "Leaving",
      accessory_id: "thermostatvirtualswitch",
      button_name: "Three",
      event: :double_press
    }
  ]

  config :home_hub, :phoscon_url, System.get_env("PHOSCON_URL", "ws://homebridge.local:443")

  config :homebridge_webhook,
    base_url: System.get_env("HOMEBRIDGE_WEBHOOK_URL", "http://homebridge.local:51828"),
    username: System.get_env("HOMEBRIDGE_WEBHOOK_USERNAME", "admin"),
    password: System.get_env("HOMEBRIDGE_WEBHOOK_PASSWORD", "admin")
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
