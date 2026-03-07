defmodule HomeHub.HomexDevice.Button3 do
  use Homex.Entity.DeviceTrigger, name: "button-3", subtype: "button_3"

  def trigger, do: GenServer.cast(:button3, {:push_value, :trigger, "action", false})
end
