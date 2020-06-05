defmodule HomeHub.Thermostat.Supervisor do
  use Supervisor

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children = [] ++ Keyword.get(opts, :children)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
