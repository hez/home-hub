defmodule HomeHubWeb.HomebridgeJSON do
  @moduledoc false
  def status(%{status: status}), do: status
  def heating_cooling_state(_), do: %{status: :ok}
  def target_temperature(_), do: %{status: :ok}
  def target_humidity(_), do: %{status: :ok}
end
