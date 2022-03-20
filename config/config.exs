# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :home_hub, :time_zone, "America/Vancouver"

config :home_hub,
  ecto_repos: [HomeHub.Repo]

# Configures the endpoint
config :home_hub, HomeHubWeb.Endpoint,
  url: [host: nil, port: 4000],
  render_errors: [view: HomeHubWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HomeHub.PubSub,
  live_view: [signing_salt: "u0O+jAdz"]

config :home_hub,
       :temperature_sensor_implementation,
       {HomeHub.Thermostat.TemperatureSensor, [dht_pin: 18]}

config :home_hub,
       :heater_io_implementation,
       {HomeHub.Thermostat.HeaterIO, [fan_pin: 17, heater_pin: 27]}

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

config :homebridge_webhook,
  base_url: System.get_env("HOMEBRIDGE_WEBHOOK_URL"),
  username: System.get_env("HOMEBRIDGE_WEBHOOK_USERNAME", "admin"),
  password: System.get_env("HOMEBRIDGE_WEBHOOK_PASSWORD", "admin")

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
    event: :single_press
  },
  %{
    name: "Leaving",
    accessory_id: "thermostatvirtualswitch",
    button_name: "Three",
    event: :single_press
  },
  %{
    name: "Test",
    accessory_id: "thermostatvirtualswitch",
    button_name: "Four",
    event: :single_press
  }
]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :home_hub, HomeHub.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :mfa]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
