defmodule HomeHub.ReportingConnection do
  @moduledoc false
  use Instream.Connection, otp_app: :home_hub
  require Logger

  def insert(%{name: name, temperature: temp, humidity: hum}) do
    temp_data = %{tags: %{host: name}, measurement: "temperature", fields: %{value: temp * 1.0}}
    humid_data = %{tags: %{host: name}, measurement: "humidity", fields: %{value: hum * 1.0}}

    case write([temp_data, humid_data]) do
      :ok -> Logger.debug("wrote to reporting connection")
      error -> Logger.warning(inspect(error))
    end

    :ok
  end

  def insert(%{temperature: _, humidity: _} = vals),
    do: vals |> Map.put(:name, tag_host()) |> insert()

  def tag_host,
    do: :home_hub |> Application.get_env(HomeHub.ReportingConnection) |> Keyword.get(:tag_host)

  def configured?, do: not is_nil(config(:host))
end
