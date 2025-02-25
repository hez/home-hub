defmodule HomeHub.HAP.Supervisor do
  @moduledoc false
  use Supervisor

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children =
      switch_children() ++
        [
          Keyword.get(opts, :hap_thermostat_module),
          {HAP, accessory_server_definition(opts)}
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

  def accessory_server_definition(opts) do
    hap_thermostat_module = Keyword.get(opts, :hap_thermostat_module)
    identifier = Keyword.get(opts, :identifier)
    name = Keyword.get(opts, :name, "Home Hub")
    model = Keyword.get(opts, :model, "Home Hub")

    %HAP.AccessoryServer{
      name: name,
      model: model,
      identifier: identifier,
      accessory_type: 9,
      accessories: [
        hap_thermostat_module.hap_accessory_definition(),
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
