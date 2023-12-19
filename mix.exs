defmodule TcpBroker.MixProject do
  use Mix.Project

  def project do
    [
      app: :tcp_broker,
      version: "0.1.0",
      elixir: "~> 1.16-rc",
      start_permanent: Mix.env() == :prod,
      escript: escript_config(),
      deps: deps()
    ]
  end

  def escript_config do
    [
      main_module: TcpBroker.Client
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [port_socket_server: 3001],
      mod: {TcpBroker, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:socket, "~> 0.3.13"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
