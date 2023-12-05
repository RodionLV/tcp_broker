defmodule TcpBrokerTest do
  use ExUnit.Case
  doctest TcpBroker

  test "greets the world" do
    assert TcpBroker.hello() == :world
  end
end
