defmodule Kitsune.Mixfile do
  use Mix.Project

  def project do
    [app: :kitsune,
     version: "0.5.2",
     description: "Kitsune is an Elixir library for transforming the representation of data inspired by Representable.",
     package: package,
     elixir: "~> 1.1-dev",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
        {:poison, "~> 1.3"},
        {:ex_doc, "~> 0.6", only: :dev},
    ]
  end

  defp package do
    [
             contributors: ["Eric West"],
             licenses: ["MIT"],
             links: %{github: "https://github.com/edubkendo/kitsune",
                      docs: "http://hexdocs.pm/kitsune"}
    ]
  end
end
