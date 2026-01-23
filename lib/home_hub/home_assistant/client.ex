defmodule HomeHub.HomeAssistant.Client do
  use WebSockex
  require Logger

  # Adjust to your Home Assitant instance
  @url "ws://slim.local:8123/api/websocket"

  def start_link(_args) do
    WebSockex.start_link(@url, __MODULE__, %{}, name: __MODULE__)
  end

  def token, do: Application.get_env(:home_hub, :home_assistant_token)

  @impl true
  def handle_cast(msg, state) do
    {:reply, {:text, Jason.encode!(msg)}, state}
  end

  @impl true
  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, msg} ->
        Logger.debug("Received:\n#{inspect(msg)}")
        handle_msg(msg, state)

      {:error, error} ->
        Logger.warning("Couldn't decode message `#{inspect(error)}`:\n#{inspect(msg)}")
        {:ok, state}
    end
  end

  defp handle_msg(%{"type" => "auth_required"}, state) do
    reply = Jason.encode!(%{type: "auth", access_token: token()})
    {:reply, {:text, reply}, state}
  end

  defp handle_msg(msg, state) do
    Logger.warning("Unhandled message: #{inspect(msg)}")
    {:ok, state}
  end
end
