defmodule TcpBroker.BlockingQueueTest do
  use ExUnit.Case

  setup do
    {:ok, pid1} = TcpBroker.BlockingQueue.start_link()

    %{pid1: pid1}

  end

  test "blocking queue", %{pid1: pid1} do
    GenServer.cast( pid1, {:put, 1})

    assert GenServer.call( pid1, :get) == 1
  end
end
