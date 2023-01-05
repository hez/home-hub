defmodule HomeHub.Thermostat.Initializer do
  alias HomeHub.Thermostat.Status

  @winter_start %DateTime{
    year: nil,
    month: 10,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0,
    std_offset: 0,
    time_zone: "Etc/UTC",
    utc_offset: 0,
    zone_abbr: "UTC"
  }
  @winter_end %DateTime{
    year: nil,
    month: 4,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0,
    std_offset: 0,
    time_zone: "Etc/UTC",
    utc_offset: 0,
    zone_abbr: "UTC"
  }
  @winter_target_temperature 16.0

  def start_state do
    if winter_mode?(DateTime.utc_now()) do
      %Status{heating: true, target: @winter_target_temperature}
    else
      %Status{}
    end
  end

  def winter_mode?(datetime) do
    DateTime.compare(datetime, %{@winter_start | year: datetime.year}) === :gt or
      DateTime.compare(datetime, %{@winter_end | year: datetime.year}) === :lt
  end
end
