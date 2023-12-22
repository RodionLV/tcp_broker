defmodule TcpBroker.Receiver do

  def accept(socket, topic) do
    IO.puts("type is receiver #{topic}")
  end



end
