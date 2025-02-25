# Home Hub

A smart thermostat and home hub written in Elixir for the Raspberry Pi.

### Features

- Thermostat
  - Integrate with DaikinOne Smart thermostats
  - Present a web UI on a Raspberry Pi touch screen with [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view)
    - Day time dependent dimming via [rpi-screen-dimmer](https://github.com/hez/rpi-screen-dimmer)
    - Layout and styling via simple [Tailwindcss](https://tailwindcss.com)
      <img width="772" alt="Screenshot 2025-02-25 at 08 06 26" src="https://github.com/user-attachments/assets/036c5b8e-e6b7-4d14-b60c-b784dbe29dc4" />

### Missing

- Control furnace and fan via relay and [Elixir Circuits](https://github.com/elixir-circuits/circuits_gpio)
- TODO: Monitor temperature and humidity with a DHT22 using [jjcarstens DHT](https://github.com/jjcarstens/dht)
- API for possible REST based triggers
- Van build and features
  - PWM controlled lights
  - Raw button integration with Phoscon

## Installing

- Get elixir
- `iex -S mix phx.server`

## Building a Release

- `MIX_ENV=prod mix build`
- if service is already running, restart `sudo systemctl restart homehub.service`

### Installing service

- Copy service to systemd directory `sudo cp homehub.service /lib/systemd/system/`
- Restart systemd `sudo systemctl daemon-reload`
- Enable Homehub `sudo systemctl enable homehub.service`
- And reboot

### Kiosk

- Set pi to auto login to gui
- Copy chromium auto start `cp browser_kiosk_autostart.desktop ~/.config/autostart/`
- And reboot

## Pi config

- disable screen blanking `sudo raspi-config` "Display Options -> Screen Blanking"
- Packages
```
apt-get install libssl-dev automake autoconf
# firefox for kiosk
apt-get install firefox-esr
```
