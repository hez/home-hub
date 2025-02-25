defmodule HomeHub.Daikin.CallBackHandler do
  require Logger
  alias HomeHub.Thermostat.Daikin

  def update_hook(previous, device) do
    Logger.debug("New device details from Daikin #{inspect(device)}")
    ExThermostat.PubSub.broadcast(:thermostat_status, Daikin.to_thermostat(device.information))
    changes = diff(previous.information, device.information)
    HomeHub.SensorsPubSub.broadcast(:thermostat_changes, {:thermostat_changes, changes})
    HomeHub.SensorsPubSub.broadcast(:thermostat_sensors, indoor_from_daikin(device))
    HomeHub.SensorsPubSub.broadcast(:thermostat_sensors, outdoor_from_daikin(device))
  end

  def indoor_from_daikin(%DaikinOne.Device{} = device) do
    %{
      name: "thermostat",
      temperature: device.information.temp_indoor,
      humidity: device.information.hum_indoor
    }
  end

  def outdoor_from_daikin(%DaikinOne.Device{} = device) do
    %{
      name: "thermostat_outdoor",
      temperature: device.information.temp_outdoor,
      humidity: device.information.hum_outdoor
    }
  end

  @doc """
  iex> HomeHub.Daikin.CallBackHandler.diff(%{foo: :bar}, %{foo: :bar})
  nil
  iex> HomeHub.Daikin.CallBackHandler.diff(%{foo: :bar}, %{foo: :baz})
  %{foo: :baz}
  """
  def diff(nil, nil), do: nil
  def diff(nil, %DaikinOne.DeviceInformation{} = info), do: Map.from_struct(info)

  def diff(%DaikinOne.DeviceInformation{} = a, %DaikinOne.DeviceInformation{} = b),
    do: diff(Map.from_struct(a), Map.from_struct(b))

  def diff(a, b) do
    {changes, equal} = Enum.reduce(a, {%{}, true}, &compare(&1, &2, b))

    if equal do
      nil
    else
      changes
      |> Map.reject(fn {_key, val} -> Map.get(val, :changed) == :equal end)
      |> Map.new(fn {k, %{added: v}} -> {k, v} end)
    end
  end

  defp compare({key, _} = el, acc, b), do: compare(el, acc, b[key], Map.has_key?(b, key))

  defp compare({key, val}, {changes, equal?}, val, true),
    do: {Map.put(changes, key, %{changed: :equal, value: val}), equal?}

  defp compare({key, vala}, {changes, _}, valb, true),
    do: {Map.put(changes, key, %{removed: vala, added: valb}), false}
end
