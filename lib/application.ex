defmodule TcpBroker do
  use Application

  def start(_type, _args) do
    port = Application.get_env(:tcp_broker, :port_socket_server)

    children = [
      TcpBroker.BlockingQueue,
      {TcpBroker.Server, [port]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
