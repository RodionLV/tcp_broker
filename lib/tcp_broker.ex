defmodule TcpBroker do
  use Application



  def start(_type, _args) do
    children = [
      %{
        id: TcpBroker.BlockingQueue,
        start: {TcpBroker.BlockingQueue, :start_link, [[]]}
      },
      # %{
      #   id: TcpBroker,
      #   start: {TcpBroker, :hello, []}
      # },
    ]


    Supervisor.start_link(children, strategy: :one_for_one)

  end

  def hello do
    :world
  end
end
