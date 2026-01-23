defmodule HomeAssistant.MQTTDevice.Button do
  @topic_prefix "homeassistantex"
  @button_id "home_hub_buttons"
  @name "Home Hub Soft Buttons"
  @button_actions Enum.map(1..6, fn idx ->
                    %{
                      type: "action",
                      device: %{
                        name: @name,
                        model: "SoftButton",
                        manufacturer: "BeamMaintenance",
                        identifiers: ["homeassistant_ex_buttons"]
                      },
                      origin: %{name: "HomeAssistantEx"},
                      payload: "action#{idx}",
                      topic: "#{@topic_prefix}/#{@button_id}/action",
                      automation_type: :trigger,
                      subtype: "action#{idx}"
                    }
                  end)

  def new, do: @button_actions

  def action_topic, do: [@topic_prefix, @button_id, "action"]

  def config_topic(button),
    do: ["homeassistant", "device_automation", @button_id, "button_#{button.subtype}", "config"]

  def send_discovery(conn, buttons) do
    buttons
    |> List.wrap()
    |> Enum.each(fn button ->
      HomeAssistant.Conn.publish(conn, config_topic(button), button)
    end)
  end

  def initialize do
    conn = HomeAssistant.Conn.new()
    send_discovery(conn, new())
  end

  def fire(action) do
    conn = HomeAssistant.Conn.new()
    HomeAssistant.Conn.publish(conn, action_topic(), action)
  end
end
