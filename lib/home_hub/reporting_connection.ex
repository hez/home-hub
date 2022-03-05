defmodule HomeHub.ReportingConnection do
  @moduledoc false
  use Instream.Connection, otp_app: :home_hub
  require Logger

  @tag_host :home_hub
            |> Application.compile_env(HomeHub.ReportingConnection)
            |> Keyword.get(:tag_host)
  @database :home_hub
            |> Application.compile_env(HomeHub.ReportingConnection)
            |> Keyword.get(:database)

  def insert(%{temperature: temp, humidity: hum}) do
    temp_data = %{tags: %{host: @tag_host}, measurement: "temperature", fields: %{value: temp}}
    humid_data = %{tags: %{host: @tag_host}, measurement: "humidity", fields: %{value: hum}}

    case write(%{points: [temp_data, humid_data], database: @database}) do
      :ok -> :ok
      error ->
        Logger.warn(inspect(error))
        error
    end
  end
end
