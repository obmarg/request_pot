defmodule RequestPot.Mixfile do
  use Mix.Project

  def project do
    [app: :request_pot,
     version: "0.2.4",
     elixir: "~> 1.0",
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
       :uuid
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
     {:gproc, "~> 0.5.0"},
     {:poison, "~> 2.1"},
     {:uuid, "~> 1.1"},

     {:exrm, "~> 1.0"}
    ]
  end
end
