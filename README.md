# Home Hub

A smart thermostat and home hub written in Elixir for the Raspberry Pi.

### Features

- Thermostat
  - Monitor temperature and humidity with a DHT22 using [jjcarstens DHT](https://github.com/jjcarstens/dht)
  - Control furnace and fan via relay and [Elixir Circuits](https://github.com/elixir-circuits/circuits_gpio)
  - Present a web UI on a Raspberry Pi touch screen with [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view)
    - Day time dependent dimming via [rpi-screen-dimmer](https://github.com/hez/rpi-screen-dimmer)
    - Layout and styling via simple [Tailwindcss](https://tailwindcss.com)
  <img width="870" alt="Screen Shot Furance Off" src="https://user-images.githubusercontent.com/244021/103706957-a0513d00-4f62-11eb-966a-fe8d7fec9785.png">
  <img width="873" alt="Screen Shot Furnace On" src="https://user-images.githubusercontent.com/244021/103707099-e7d7c900-4f62-11eb-988a-b9223f1d8025.png">
- Homebridge integration
  - Present virtual Homebridge switchs [HTTP Webhooks plugin](https://github.com/benzman81/homebridge-http-webhooks)
  - Present as a thermostat to homebridge via [Thermostat plugin](https://github.com/PJCzx/homebridge-thermostat)
- Present historical data collected via InfluxDB and Grafana via [Climate Sensors](https://github.com/jrstarke/esp8266-climate-sensors) and [home-hub-logger](https://github.com/hez/home-hub-logger)
  <img width="871" alt="Screen Shot Current Temps" src="https://user-images.githubusercontent.com/244021/103707291-338a7280-4f63-11eb-8175-bb3a2a1427b6.png">
  <img width="792" alt="Screen Shot Historical Temps" src="https://user-images.githubusercontent.com/244021/103707533-a1369e80-4f63-11eb-9de7-d4a97820bf2e.png">


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

_Add env `VAN=1` if compile the van ver._

- `MIX_ENV=prod mix compile`
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
