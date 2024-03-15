defmodule TradingEconomics.MixProject do
  use Mix.Project

  def project do
    [
      app: :trading_economics,
      version: "0.1.0",
      elixir: "~> 1.16",
      name: "TradingEconomics",
      description: "TradingEconomics API Client for Elixir (https://docs.tradingeconomics.com/)",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  def package() do
    %{
      licenses: ["MIT"],
      maintainers: ["Iulian Costan"],
      links: %{"GitHub" => "https://github.com/icostan/trading_economics"}
    }
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.4.0"},
      {:mapail, "~> 1.0.0"},
      {:nimble_csv, "~> 1.2.0"},
      {:exvcr, "~> 0.11", only: [:dev, :test]}
    ]
  end
end
