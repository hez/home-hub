defmodule HomeHub.Phoscon do
  require Logger

  def fetch, do: PhosconAPI.sensors()

  @spec fetch_all() :: map()
  def fetch_all do
    case fetch() do
      {:ok, results} ->
        parse_results(results)

      err ->
        Logger.error("fetching phoscon #{inspect(err)}")
        %{}
    end
  end

  def parse_results(results) do
    results
    |> Map.values()
    |> Enum.group_by(& &1["name"])
    |> Map.new(fn {name, sensors} ->
      sensors =
        %{} |> merge_all_sensors(sensors) |> merge_battery(sensors) |> merge_lastseen(sensors)

      {name, sensors}
    end)
  end

  def merge_lastseen(map, sensors) do
    sensors
    |> Enum.map(&%{lastseen: to_datetime(&1["lastseen"])})
    |> Enum.reduce(&Map.merge/2)
    |> Map.merge(map)
  end

  def merge_battery(map, sensors) do
    sensors
    |> Enum.map(&%{battery: &1["config"]["battery"]})
    |> Enum.reduce(&Map.merge/2)
    |> Map.merge(map)
  end

  def merge_all_sensors(map, sensors),
    do: sensors |> Enum.map(&parse_sensor/1) |> Enum.reduce(&Map.merge/2) |> Map.merge(map)

  defp parse_sensor(%{"state" => %{"humidity" => v}}), do: %{humidity: v / 100.0}
  defp parse_sensor(%{"state" => %{"temperature" => v}}), do: %{temperature: v / 100.0}
  defp parse_sensor(%{"state" => %{"pressure" => v}}), do: %{pressure: v}
  defp parse_sensor(_), do: %{}

  defp to_datetime(ts) when is_binary(ts) do
    case ts |> String.replace("Z", ":00Z") |> DateTime.from_iso8601() do
      {:ok, ts, _} -> ts
      _ -> nil
    end
  end

  defp to_datetime(_), do: nil
end
