defmodule HomeHub.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :home_hub,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      deps: deps()
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
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # Everything else
      {:circuits_gpio, "~> 1.0"},
      {:dht, "~> 0.1"},
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:finch, "~> 0.13"},
      {:gettext, "~> 0.20"},
      {:hap, "~> 0.4"},
      {:heroicons, "~> 0.5"},
      {:instream, "~> 2.2"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7.0-rc.0", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_view, "~> 0.20"},
      {:phoscon_api, github: "hez/phoscon_api", tag: "v0.3.6"},
      {:pid_controller, github: "hez/pid_controller", branch: "minmax"},
      {:pidex, github: "hez/pidex", branch: "feature/debug-touchups"},
      {:pigpiox, github: "hez/pigpiox", runtime: false},
      {:plug_cowboy, "~> 2.5"},
      {:rpi_screen_dimmer, github: "hez/rpi-screen-dimmer", branch: "feature/input-event-upstream", only: :prod},
      {:swoosh, "~> 1.3"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:tzdata, "~> 1.1.0"}
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
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      build: ["deps.get", "compile", "assets.deploy", "release --overwrite"]
    ]
  end
end
