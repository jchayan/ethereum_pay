defmodule EthereumPay.MixProject do
  use Mix.Project

  def project do
    [
      app: :ethereum_pay,
      version: "0.1.0",
      elixir: "~> 1.9.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:cowboy, :logger, :poison],
      mod: { EthereumPay, [] }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:mutex, "~> 1.1.0"},
      {:recon, "~> 2.3.1", only: :dev},
      {:poison, "~> 3.1"},
      {:jason, "~> 1.2"},
      {:maru, "~> 0.14.0-pre.1"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_rlp, "~> 0.5.3", override: true},
      # {:ethereumex, git: "https://github.com/jchayan/ethereumex", override: true},
      {:ethereumex, "~> 0.6.4", override: true},
      {:eth, git: "https://github.com/jchayan/eth"},
      {:memoize, "~> 1.3"},
      {:httpoison, "~> 1.6", override: true}
    ]
  end
end
