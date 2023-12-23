defmodule TcpBroker.Receiver do

  require Logger

  def accept(socket, topic) do
    Logger.info("type is receiver in topic: #{topic}")

    spawn_link(fn->
      loop(socket, topic)
    end)
  end



  def loop(socket, topic) do
    {:value, data} = TcpBroker.BlockingQueue.get(topic);

    Logger.info("receive data: #{data}")

    :gen_tcp.send(socket, data)

    loop(socket, topic)
  end



end
