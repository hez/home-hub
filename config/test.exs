import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :home_hub, HomeHub.Repo,
  database: Path.expand("../home_hub_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :home_hub, HomeHubWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "B6J9b9RJTdDToq4hme8Alb7GgZczpoEgUO+Khk/b2MH+vZyLPsISw8YfZlLQTkpW",
  server: false

# In test we don't send emails.
config :home_hub, HomeHub.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :home_hub, :thermostat,
  io_config: {Thermostat.DummyHeater, []},
  sensor_config: {Thermostat.DummyTempSensor, []}
