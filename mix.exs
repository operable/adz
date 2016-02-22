defmodule Adz.Mixfile do
  use Mix.Project

  def project do
    [app: :adz,
     version: "0.2",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:poison, "~> 1.5.2"}]
  end
end
