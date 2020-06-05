defmodule HomeHub.IO.SmallButton do
  use PhosconAPI.Button

  alias HomeHub.Lights

  # Long press
  @impl PhosconAPI.Button
  def handle(_id, 1003, %{long_press: light}) do
    Lights.toggle(light)
  end

  @impl PhosconAPI.Button
  def handle(_id, _event, _config), do: :ok
end
