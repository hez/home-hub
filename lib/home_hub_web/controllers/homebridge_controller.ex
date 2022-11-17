defmodule HomeHubWeb.HomebridgeController do
  @moduledoc false
  use HomeHubWeb, :controller

  alias HomeHub.Thermostat

  action_fallback HomeHubWeb.FallbackController

  def status(conn, _),
    do: render(conn, :status, status: Thermostat.Homebridge.convert(Thermostat.status()))

  # Turn off
  def heating_cooling_state(conn, %{"target" => "0"}) do
    Thermostat.stop_heat()
    render(conn, :heating_cooling_state)
  end

  # Turn on heating
  def heating_cooling_state(conn, %{"target" => "1"}) do
    Thermostat.start_heat()
    render(conn, :heating_cooling_state)
  end

  # Turn on cooling
  # NOTE unsupported
  def heating_cooling_state(conn, %{"target" => "2"}),
    do: render(conn, :heating_cooling_state)

  # Turn on auto
  # NOTE unsupported
  def heating_cooling_state(conn, %{"target" => "3"}),
    do: render(conn, :heating_cooling_state)

  # Set target temperature
  def target_temperature(conn, %{"target" => target}) do
    target
    |> Float.parse()
    |> elem(0)
    |> Thermostat.set_target()

    render(conn, :target_temperature)
  end

  # NOTE unsupported
  def target_humidity(conn, _params), do: render(conn, :target_humidity)
end
