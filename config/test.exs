import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :home_hub, HomeHub.Repo,
  database: Path.expand("../home_hub_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :home_hub, HomeHubWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fydU52pCnpJEgvajRgZ1TBQTRTHj+FijYFw3gJ+tLNGQ11xyrOPTz76cureQyQaI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :home_hub, :thermostat,
  io_config: {ExThermostat.DummyHeater, []},
  sensor_config: {ExThermostat.DummyTempSensor, []}

config :home_hub, :hap_config,
  hap_thermostat_module: HomeHub.HAP.DevThermostat,
  identifier: "22:22:33:44:99:78",
  name: "Home Hub Dev",
  model: "HomeHubDev"
