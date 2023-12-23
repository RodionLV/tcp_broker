defmodule TcpBroker.BlockingQueueTest do
  use ExUnit.Case


  # setup do
  #   {:ok, pid1} = TcpBroker.BlockingQueue.start_link()

  #   %{pid1: pid1}

  # end

  # test "blocking queue", %{pid1: pid1} do

  #   spawn( fn->
  #     data = TcpBroker.BlockingQueue.get( pid1)
  #     IO.puts("value: #{inspect(data)}")
  #   end)

  #   Process.sleep(1000)

  #   TcpBroker.BlockingQueue.put( pid1, 1 )

  #   TcpBroker.BlockingQueue.put( pid1, 2 )



  #   assert TcpBroker.BlockingQueue.get( pid1) == {:value, 2}
  # end
end
