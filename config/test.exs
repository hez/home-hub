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
  secret_key_base: "wn9MH6RMXYheEdAV0m4DxLvKqDpSLJQIqMUU//5bQUl1HFcJZnqub2/FcPRh0gGs",
  server: false

config :home_hub, :temperature_sensor_implementation, {HomeHub.Thermostat.DummyTempSensor, []}

# In test we don't send emails.
config :home_hub, HomeHub.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
