defmodule HomeHub.HomexDevice.Button5 do
  use Homex.Entity.DeviceTrigger, name: "button-5", subtype: "button_5"

  def trigger, do: GenServer.cast(:button5, {:push_value, :trigger, "action", false})
end
