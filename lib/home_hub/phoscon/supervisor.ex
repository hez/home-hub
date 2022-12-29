defmodule HomeHub.Phoscon.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger
  alias HomeHub.Phoscon

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(_opts) do
    children = [
      {Phoenix.PubSub, name: Phoscon.PubSub},
      Phoscon.Server
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
