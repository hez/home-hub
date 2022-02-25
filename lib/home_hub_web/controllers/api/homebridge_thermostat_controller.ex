defmodule HomeHubWeb.API.HomebrigeThermostatController do
  use HomeHubWeb, :controller

  def status(conn, _),
    do: render(conn, "status.json", %{status: HomeHub.Thermostat.homebridge_status()})

  # Turn off
  def heating_cooling_state(conn, %{"target" => "0"}) do
    HomeHub.Thermostat.stop_heat()
    render(conn, "heating_cooling_state.json")
  end

  # Turn on heating
  def heating_cooling_state(conn, %{"target" => "1"}) do
    HomeHub.Thermostat.start_heat()
    render(conn, "heating_cooling_state.json")
  end

  # Turn on cooling
  # NOTE unsupported
  def heating_cooling_state(conn, %{"target" => "2"}),
    do: render(conn, "heating_cooling_state.json")

  # Turn on auto
  # NOTE unsupported
  def heating_cooling_state(conn, %{"target" => "3"}),
    do: render(conn, "heating_cooling_state.json")

  # Set target temperature
  def target_temperature(conn, %{"target" => target}) do
    target
    |> Float.parse()
    |> elem(0)
    |> HomeHub.Thermostat.set_target()

    render(conn, "target_temperature.json")
  end

  # NOTE unsupported
  def target_humidity(conn, _params), do: render(conn, "target_humidity.json")
end

