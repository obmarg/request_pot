defmodule RequestPot.Mixfile do
  use Mix.Project

  def project do
    [app: :request_pot,
     version: "0.3.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {RequestPot, []},
     applications: [
       :phoenix, :phoenix_html, :cowboy, :logger, :gettext, :gproc,
       :uuid, :exometer_datadog, :elixometer
     ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:gproc, "~> 0.6.1"},
     {:poison, "~> 2.0"},
     {:uuid, "~> 1.1"},

     {:exrm, "~> 1.0"},

     {:exometer_datadog, "~> 0.4"},
     {:elixometer, "~> 1.2.1"},

     {:lager, "~> 3.6.1", override: true}
    ]
  end
end
