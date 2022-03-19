defmodule HomeHub.Homebridge.Supervisor do
  @moduledoc false
  use Supervisor

  @name __MODULE__

  @switches Application.compile_env!(:home_hub, :switches)

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(_opts) do
    children = [{HomeHub.Homebridge.Switches, switches: @switches}]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
