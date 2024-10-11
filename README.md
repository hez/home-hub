# Home Hub

A smart thermostat and home hub written in Elixir for the Raspberry Pi.

### Features

- Thermostat
  - Monitor temperature and humidity with a DHT22 using [jjcarstens DHT](https://github.com/jjcarstens/dht)
  - Control furnace and fan via relay and [Elixir Circuits](https://github.com/elixir-circuits/circuits_gpio)
  - Present a web UI on a Raspberry Pi touch screen with [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view)
    - Day time dependent dimming via [rpi-screen-dimmer](https://github.com/hez/rpi-screen-dimmer)
    - Layout and styling via simple [Tailwindcss](https://tailwindcss.com)
      <img width="982" alt="Screenshot 2022-12-29 at 16 58 56" src="https://user-images.githubusercontent.com/244021/210024638-0044aa8f-220c-469b-8627-8c5522e90d84.png">
      <img width="995" alt="Screenshot 2022-12-29 at 16 33 56" src="https://user-images.githubusercontent.com/244021/210024645-d7a7ffd4-1b54-49b6-8bc8-ef46f984c5a0.png">

- Present historical data collected via InfluxDB and Grafana via [Climate Sensors](https://github.com/jrstarke/esp8266-climate-sensors) and [home-hub-logger](https://github.com/hez/home-hub-logger)
  <img width="781" alt="Screenshot 2022-12-11 at 14 08 18" src="https://user-images.githubusercontent.com/244021/206931768-60cafc84-ef8c-4661-9951-bf68049c0053.png">

### Missing

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
