defmodule TcpBroker.BlockingQueue do
  use GenServer

  def start_link(state \\ {[], []}) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    IO.puts("Starting BlockingQueue")
    {:ok, state}
  end

  def put(pid, value), do: GenServer.cast(pid, {:put, value})

  def get(pid), do: GenServer.call(pid, :get, :infinity)



  def handle_cast({:put, value}, {state, []}) do
    new_state = _put(state, value)

    {:noreply, {new_state, []}}
  end
  def handle_cast({:put, new_value}, {state, [client | other]}) do
    [value | new_state] = _put(state, new_value)

    GenServer.reply(client, {:value, value})

    {:noreply, {state, new_state}}
  end


  def handle_call(:get, from, { [], wait }) do
    {:noreply, {[], [from | wait]}}
  end
  def handle_call(:get, from, { [value | new_state], wait }) do
    {:reply, {:value, value}, {new_state, wait}}
  end



  defp _put([], value), do: [value|[]]
  defp _put([h|t], value), do: [h|_put(t, value)]

end
