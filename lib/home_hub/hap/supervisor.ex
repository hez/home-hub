defmodule HomeHub.HAP.Supervisor do
  @moduledoc false
  use Supervisor

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(_opts) do
    children =
      switch_children() ++
        [
          HomeHub.HAP.Thermostat,
          {HAP, accessory_server_definition()}
        ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def switch_config do
    ["Switch 1", "Switch 2", "Switch 3"]
    |> Enum.with_index(fn name, index ->
      {HomeHub.HAP.StatelessSwitch, name: :"hap_switch_#{index + 1}", display: name}
    end)
  end

  def switch_children do
    Enum.with_index(switch_config(), fn switch, index ->
      Supervisor.child_spec(switch, id: {HomeHub.HAP.StatelessSwitch, index + 1})
    end)
  end

  def accessory_server_definition do
    %HAP.AccessoryServer{
      name: "Home Hub",
      model: "HomeHub",
      identifier: "11:22:33:44:12:78",
      accessory_type: 9,
      accessories: [
        %HAP.Accessory{
          name: "Thermostat",
          services: [
            %HAP.Services.Thermostat{
              name: "Thermostat",
              current_state: {HomeHub.HAP.Thermostat, :current_state},
              current_temp: {HomeHub.HAP.Thermostat, :current_temp},
              current_humidity: {HomeHub.HAP.Thermostat, :current_humidity},
              target_state: {HomeHub.HAP.Thermostat, :target_state},
              target_temp: {HomeHub.HAP.Thermostat, :target_temp},
              temp_display_units: {HomeHub.HAP.Thermostat, :temp_display_units}
            }
          ]
        },
        %HAP.Accessory{
          name: "Virtual Switches",
          services:
            Enum.with_index(
              switch_config(),
              &%HAP.Services.StatelessProgrammableSwitch{
                input_event: &1,
                name: Keyword.get(elem(&1, 1), :display),
                service_label_index: &2 + 1
              }
            )
        }
      ]
    }
  end
end
