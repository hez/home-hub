# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay",
  provisioning: "config/provisioning.conf"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1721520436"

config :mix_tasks_upload_hotswap,
  app_name: :home_hub,
  nodes: [:"home_hub@homehub.local"],
  cookie: :nerves_is_awesome

config :homex,
  device: [
    name: "Home Hub Soft Buttons" <> System.get_env("HOMEX_SUFFIX", ""),
    model: "SoftButton",
    manufacturer: "BeamMaintenance"
  ],
  origin: [
    name: "HomeAssistantEx"
  ],
  broker: [
    host: "MQTT_HOSTNAME" |> System.get_env("localhost"),
    port: "MQTT_PORT" |> System.get_env("1883") |> String.to_integer()
  ],
  entities: [
    [name: :button1, impl: HomeHub.HomexDevice.Button1],
    [name: :button2, impl: HomeHub.HomexDevice.Button2],
    [name: :button3, impl: HomeHub.HomexDevice.Button3],
    [name: :button4, impl: HomeHub.HomexDevice.Button4],
    [name: :button5, impl: HomeHub.HomexDevice.Button5],
    [name: :button6, impl: HomeHub.HomexDevice.Button6]
  ]

# Homex.WebsocketClient will use these to connect to Home Assistant's Websocket API
config :home_hub,
  home_assistant_host: System.get_env("HOME_ASSISTANT_HOST"),
  home_assistant_port: 8123,
  home_assistant_access_token: System.get_env("HOME_ASSISTANT_TOKEN"),
  home_assistant_token: System.get_env("HOME_ASSISTANT_TOKEN")

import_config "phoenix/config.exs"

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
