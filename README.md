# Home Hub

A smart thermostat and home hub written in Elixir for the Raspberry Pi.

### Features

- Thermostat
  - Monitor temperature and humidity with a DHT22 using [jjcarstens DHT](https://github.com/jjcarstens/dht)
  - Control furnace and fan via relay and [Elixir Circuits](https://github.com/elixir-circuits/circuits_gpio)
  - Present a web UI on a Raspberry Pi touch screen with [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view)
    - Day time dependent dimming via [rpi-screen-dimmer](https://github.com/hez/rpi-screen-dimmer)
    - Layout and styling via simple [Tailwindcss](https://tailwindcss.com)
      <img width="793" alt="Screenshot 2022-12-11 at 14 07 22" src="https://user-images.githubusercontent.com/244021/206931738-3fdeb222-cfda-4e97-a05f-70801621564e.png">
      <img width="794" alt="Screenshot 2022-12-11 at 14 08 03" src="https://user-images.githubusercontent.com/244021/206931744-a8bfb89a-a07a-4650-8a98-fc6e0151eb94.png">

- Homebridge integration
  - Present virtual Homebridge switchs [HTTP Webhooks plugin](https://github.com/benzman81/homebridge-http-webhooks)
  - Present as a thermostat to homebridge via [Thermostat plugin](https://github.com/PJCzx/homebridge-thermostat)
- Present historical data collected via InfluxDB and Grafana via [Climate Sensors](https://github.com/jrstarke/esp8266-climate-sensors) and [home-hub-logger](https://github.com/hez/home-hub-logger)
  <img width="781" alt="Screenshot 2022-12-11 at 14 08 18" src="https://user-images.githubusercontent.com/244021/206931768-60cafc84-ef8c-4661-9951-bf68049c0053.png">



### Missing

- winter mode
  A mode that will ensure furnace is on even with a reset. (Date dependant? File dependant?)
- API for possible REST based triggers
- Van build and features
  - PWM controlled lights
  - Raw button integration with Phoscon

## Installing

- Get elixir
- `iex -S mix phx.server`

## Building a Release

- `MIX_ENV=prod mix compile`
- `MIX_ENV=prod mix assets.deploy`
- `MIX_ENV=prod mix release`
- if service is already running, restart `sudo systemctl restart homehub.service`

### Installing service

- Copy service to systemd directory `sudo cp homehub.service /lib/systemd/system/`
- Restart systemd `sudo systemctl daemon-reload`
- Enable Homehub `sudo systemctl enable homehub.service`
- And reboot

### Kiosk

- Set pi to auto login to gui
- Copy chromium auto start `cp chromium_autostart.desktop ~/.config/autostart/`
- And reboot

### Homebridge configuration

Using the [homebridge-thermostat](https://github.com/PJCzx/homebridge-thermostat#readme) plugin
you can control the thermostat with HomeKit.

```
  {
      "accessory": "Thermostat",
      "name": "Thermostat",
      "apiroute": "http://192.168.1.114/",
      "currentHumidity": true,
      "maxTemp": 24,
      "minTemp": 10
  }
```

## Pi config

- disable screen blanking `sudo raspi-config` "Display Options -> Screen Blanking"
- Packages
```
apt-get install libssl-dev automake autoconf
```
