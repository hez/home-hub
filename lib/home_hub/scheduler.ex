defmodule HomeHub.Scheduler do
  use Quantum, otp_app: :home_hub

  require Logger

  # credo:disable-for-next-line
  if Mix.env() == :prod do
    @time_zone Application.compile_env(:home_hub, :time_zone)

    @morning_hour 6
    @evening_hour 19

    @day_active_level 128
    @day_inactive_level 35
    @night_active_level 50
    @night_inactive_level 15

    def check_screen_levels do
      {:ok, cur_time} = DateTime.now(@time_zone)

      if cur_time.hour >= @morning_hour and cur_time.hour < @evening_hour do
        RpiScreenDimmer.active_level(@day_active_level)
        RpiScreenDimmer.inactive_level(@day_inactive_level)
      else
        RpiScreenDimmer.active_level(@night_active_level)
        RpiScreenDimmer.inactive_level(@night_inactive_level)
      end
    end
  else
    def check_screen_levels do
      Logger.debug("noop checking screen levels")
    end
  end
end
