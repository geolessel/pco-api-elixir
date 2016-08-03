defmodule PcoApi.Mixfile do
  use Mix.Project

  def project do
    [app: :pco_api,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:poison, "~> 2.0"},
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:bypass, git: "https://github.com/PSPDFKit-labs/bypass", only: :test},
      {:mix_test_watch, "~> 0.2", only: :dev}
    ]
  end

  defp description do
    """
    An Elixir wrapper for the Planning Center API
    """
  end

  defp package do
    [
      name: :pco_api,
      maintainers: ["Geoffrey Lessel", "Jesse Anderson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/geolessel/pco-api-elixir"}
    ]
  end
end
