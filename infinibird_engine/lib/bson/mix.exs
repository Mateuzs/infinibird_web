defmodule Bson.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bson,
      name: "bson",
      version: "0.4.5",
      elixir: "~> 1.8",
      description: "BSON implementation for Elixir",
      source_url: "https://github.com/checkiz/elixir-bson",
      deps: deps(Mix.env())
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  defp deps(_), do: []

  defp package do
    [
      contributors: ["jerp", "Mateuzs"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/checkiz/elixir-bson",
        "Documentation" => "http://hexdocs.pm/bson/"
      }
    ]
  end
end
