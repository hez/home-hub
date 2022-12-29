# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :home_hub,
  ecto_repos: [HomeHub.Repo]

# Configures the endpoint
config :home_hub, HomeHubWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: HomeHubWeb.ErrorHTML, json: HomeHubWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HomeHub.PubSub,
  live_view: [signing_salt: "9OFXxlLU"]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :home_hub, HomeHub.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
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

config :phoscon_api, :connection,
  host: System.get_env("PHOSCON_HOST"),
  api_key: System.get_env("PHOSCON_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
