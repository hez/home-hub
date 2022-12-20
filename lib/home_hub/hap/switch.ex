defmodule HomeHub.HAP.Switch do
  @moduledoc """
  Responsible for representing a HAP switch
  """

  @behaviour HAP.ValueStore

  use GenServer

  require Logger

  def start_link(config),
    do: GenServer.start_link(__MODULE__, config, name: Keyword.get(config, :name))

  @impl HAP.ValueStore
  def get_value(opts), do: GenServer.call(Keyword.get(opts, :name), {:get, opts})

  @impl HAP.ValueStore
  def put_value(value, opts), do: GenServer.call(Keyword.get(opts, :name), {:put, value, opts})

  @impl HAP.ValueStore
  def set_change_token(change_token, opts),
    do: GenServer.call(Keyword.get(opts, :name), {:set_change_token, change_token, opts})

  def toggle(name), do: GenServer.call(name, {:toggle, name})

  @impl GenServer
  def init(_), do: {:ok, %{on: 0, change_token: nil}}

  @impl GenServer
  def handle_call({:get, opts}, _from, state) do
    Logger.debug("Getting state for #{inspect(opts)} #{inspect(state)}")
    {:reply, {:ok, state.on}, state}
  end

  @impl GenServer
  def handle_call({:put, value, opts}, _from, state) do
    Logger.debug("put state for #{inspect(opts)} #{inspect(state)} new #{value}")
    {:reply, :ok, %{state | on: value}}
  end

  @impl GenServer
  def handle_call({:set_change_token, change_token, opts}, _from, state) do
    Logger.debug("new change token for #{inspect(opts)} #{inspect(change_token)}")
    {:reply, :ok, %{state | change_token: change_token}}
  end

  def handle_call({:toggle, name}, _from, state) do
    Logger.debug("toggling #{name}")
    new_on_state = if state.on == 1, do: 0, else: 1
    HAP.value_changed(state.change_token)
    {:reply, :ok, %{state | on: new_on_state}}
  end
end
