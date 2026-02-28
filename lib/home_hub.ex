defmodule HomeHub do
  @moduledoc """
  HomeHub keeps the contexts that define your domain
  and business logic.
  """
  @thermostat_implementation Application.compile_env!(:home_hub, :thermostat_implementation)
  def thermostat_implementation, do: @thermostat_implementation

  @spec winter_mode?(Keyword.t(), Date.t()) :: boolean()
  def winter_mode?(options \\ [], date) do
    winter_start = %{Keyword.get(options, :winter_start, ~D[2000-10-01]) | year: date.year}
    winter_end = %{Keyword.get(options, :winter_end, ~D[2000-04-01]) | year: date.year}
    Date.compare(date, winter_start) === :gt or Date.compare(date, winter_end) === :lt
  end

  def to_f("unknown"), do: nil
  def to_f(val) when is_binary(val), do: val |> Float.parse() |> elem(0)
  def to_f(val) when is_float(val), do: val
  def to_f(val) when is_integer(val), do: val * 1.0
end
