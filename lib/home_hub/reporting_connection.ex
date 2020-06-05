defmodule HomeHub.ReportingConnection do
  use Instream.Connection, otp_app: :home_hub

  def insert(%{temperature: temp, humidity: hum}) do
    temp_data = %{tags: %{host: host()}, measurement: "temperature", fields: %{value: temp}}
    humid_data = %{tags: %{host: host()}, measurement: "humidity", fields: %{value: hum}}
    write(%{points: [temp_data, humid_data], database: "climate"})
  end

  def host do
    :home_hub
    |> Application.get_env(HomeHub.ReportingConnection)
    |> Keyword.get(:tag_host, :home_hub)
  end
end
