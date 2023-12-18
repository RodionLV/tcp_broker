defmodule TcpBroker do
  use Application

  def start(_type, _args) do
    children = [
      TcpBroker.BlockingQueue
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
