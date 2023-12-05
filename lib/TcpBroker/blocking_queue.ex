defmodule TcpBroker.BlockingQueue do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:test, msg}, from, state) do

    IO.puts("start: #{msg} time: #{Time.utc_now()}")
    Process.sleep(15000)
    IO.puts("reply: #{msg} #{state} time: #{Time.utc_now()}")

    {:reply, msg, state}
  end



  def handle_cast({:put, value}, state) do
    {:noreply, [value | state]}
  end

  def handle_call(:get, _from, [value | state]) do
    {:reply, value, state}
  end

end
