defmodule HomeHubWeb.API.HomebrigeThermostatView do
  use HomeHubWeb, :view

  def render("status.json", %{status: status}) do
    status
  end

  def render("heating_cooling_state.json", _) do
    %{status: :ok}
  end

  def render("target_temperature.json", _) do
    %{status: :ok}
  end

  def render("target_humidity.json", _) do
    %{status: :ok}
  end
end
