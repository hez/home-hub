defmodule HomeHub.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :home_hub,
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit, :pigpiox],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HomeHub.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Dev and test
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # Prod only
      {:rpi_screen_dimmer, github: "hez/rpi-screen-dimmer", tag: "v0.1.0", only: :prod},
      # Everything else
      {:circuits_gpio, "~> 0.4"},
      {:dht, "~> 0.1"},
      {:gettext, "~> 0.11"},
      {:homebridge_webhook, github: "hez/elixir-homebridge-webhook-client", tag: "v0.1.2"},
      {:instream, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_live_view, "~> 0.15"},
      {:pidex, github: "hez/pidex", branch: "feature/debug-touchups"},
      {:pigpiox, github: "hez/pigpiox", runtime: false},
      # {:pigpiox, "~> 0.1", runtime: false},
      {:plug_cowboy, "~> 2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:tzdata, "~> 1.0.3"},
      {:phoscon_api, github: "hez/phoscon_api", tag: "v0.2.0"},
      # Stateless HTTP switch
      {:quantum, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      build: [
        "deps.get --only prod",
        "cmd npm install --prefix ./assets",
        "cmd npm run deploy --prefix ./assets",
        "phx.digest",
        "release"
      ]
    ]
  end
end
