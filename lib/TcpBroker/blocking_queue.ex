defmodule TcpBroker.BlockingQueue do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end


  def put(pid, value) do
    GenServer.cast(pid, {:put, value})
  end

  def get(pid) do
    case GenServer.call(pid, :get) do
      :block -> get(pid)
      {:value, value}->value
    end
  end


  def handle_cast({:put, value}, state) do
    new_state = _put(state, value)
    IO.inspect(new_state)
    {:noreply, new_state}
  end


  def handle_call(:get, from, []) do
    {:reply, :block, []}
  end
  def handle_call(:get, from, [value | new_state]) do
    {:reply, {:value, value}, new_state}
  end


  defp _put([], value), do: [value|[]]
  defp _put([h|t], value), do: [h|_put(t, value)]

end
