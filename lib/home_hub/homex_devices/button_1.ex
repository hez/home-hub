defmodule HomeHub.HomexDevice.Button1 do
  use Homex.Entity.DeviceTrigger, name: "button-1", subtype: "button_1"

  def trigger, do: GenServer.cast(:button1, {:push_value, :trigger, "action", false})
end
