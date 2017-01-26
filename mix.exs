defmodule Adz.Mixfile do
  use Mix.Project

  def project do
    [app: :adz,
     version: "1.0.0-beta.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poison, "~> 2.0"}]
  end
end
