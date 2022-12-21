defmodule HomeHub.ReportingConnection do
  @moduledoc false
  use Instream.Connection, otp_app: :home_hub
  require Logger

  def insert(%{temperature: temp, humidity: hum}) do
    temp_data = %{tags: %{host: tag_host()}, measurement: "temperature", fields: %{value: temp}}
    humid_data = %{tags: %{host: tag_host()}, measurement: "humidity", fields: %{value: hum}}

    case write([temp_data, humid_data]) do
      :ok ->
        :ok

      error ->
        Logger.warn(inspect(error))
        error
    end
  end

  def tag_host,
    do: :home_hub |> Application.get_env(HomeHub.ReportingConnection) |> Keyword.get(:tag_host)

  def configured?, do: not is_nil(config(:host))
end
