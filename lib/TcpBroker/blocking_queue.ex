defmodule TcpBroker.BlockingQueue do
  use GenServer
  require Logger

  def start_link(state \\ {%{}, []}) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    Logger.info("Starting BlockingQueue")
    {:ok, state}
  end

  def put(pid, topic, value),
    do: GenServer.cast(pid, {:put, topic, value})

  def get(pid),
    do: GenServer.call(pid, :get, :infinity)


  def handle_cast({:put, topic, elem}, {state, []}) do
    new_state = _put_state(state, topic, elem)

    {:noreply, {new_state, []}}
  end

  def handle_cast({:put, topic, elem}, {state, [client | other]}) do
    new_state = case  Map.fetch(state, topic) do
      {:ok, list}->
        [value | new_list] = _put(list, elem)

        GenServer.reply(client, {:value, value})

        Map.replace(state, topic, new_list)
      :error->
        GenServer.reply(client, {:value, elem})
        state
    end

    {:noreply, {new_state, other}}
  end


  def handle_call({:get, topic}, from, { state, wait }) do
    case _get_state(state, topic) do
      {nil, []}->
        {:noreply, {%{}, [from | wait]}}
      {value, new_list}->
        new_state = Map.replace(state, topic, new_list)
        {:reply, {:value, value}, {new_state, wait}}
    end
  end


  defp _get_state(state, topic) do
    case  Map.fetch(state, topic) do
      {:ok, list}->
        [value | new_list] = list
        {value, new_list}
      :error->
        {nil, []}
    end
  end

  defp _put_state(state, topic, elem) do
    case  Map.fetch(state, topic) do
      {:ok, list}->
        new_list = _put(list, elem)
        Map.replace(state, topic, new_list)
      :error->
        Map.put(state, topic, [elem])
    end
  end


  defp _put([], value), do: [value|[]]
  defp _put([h|t], value), do: [h|_put(t, value)]
end
