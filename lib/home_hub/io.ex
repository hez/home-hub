defmodule HomeHub.IO do
  require Logger

  @callback on() :: :ok | {:error, any()}
  @callback off() :: :ok | {:error, any()}
  @callback state() :: true | false

  defmacro __using__(_) do
    quote do
      use Agent

      require Logger

      @name __MODULE__
      def name, do: @name

      def update(true), do: on()
      def update(false), do: off()

      def start_link(opts) do
        pin = Keyword.get(opts, :pin)
        Logger.debug("starting on pin #{pin}", label: @name)
        {:ok, circuit} = Circuits.GPIO.open(pin, :output)
        Agent.start_link(fn -> %{gpio: circuit} end, name: @name)
      end

      defoverridable start_link: 1

      def on, do: Circuits.GPIO.write(gpio(), 1)

      defoverridable on: 0

      def off, do: Circuits.GPIO.write(gpio(), 0)

      defoverridable off: 0

      def state, do: Circuits.GPIO.read(gpio()) == 1

      defoverridable state: 0

      def gpio, do: Agent.get(@name, &Map.get(&1, :gpio))
    end
  end
end
