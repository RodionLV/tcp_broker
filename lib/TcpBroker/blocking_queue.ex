defmodule TcpBroker.BlockingQueue do
  use GenServer
  require Logger

  def start_link(state \\ {%{}, %{}}) do
    IO.inspect(state)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting BlockingQueue")
    {:ok, state}
  end

  def put(topic, value),
    do: GenServer.cast(__MODULE__, {:put, topic, value})

  def get(topic),
    do: GenServer.call(__MODULE__, {:get, topic}, :infinity)



  def handle_cast({:put, topic, elem}, {state, waits}) do
    case Map.fetch(waits, topic) do
      {:ok, []}->
        new_state = _put_state(state, topic, elem)
        {:noreply, {new_state, waits}}
      :error->
        new_state = _put_state(state, topic, elem)

        IO.inspect(new_state)
        {:noreply, {new_state, waits}}
      {:ok, [client| other]}->
        list = _get_state(state, topic)

        [value | new_list] = _put(list, elem)

        GenServer.reply(client, {:value, value})

        {:noreply, {
          Map.replace(state, topic, new_list),
          Map.replace(waits, topic, other)
        }}
    end
  end


  def handle_call({:get, topic}, from, { state, waits }) do
    case _get_state(state, topic) do
      []->
        new_map = _put_state(waits, topic, from)
        {:noreply, {%{}, new_map}}
      list->
        [value | new_list] = list
        new_state = Map.replace(state, topic, new_list)
        {:reply, {:value, value}, {new_state, waits}}
    end
  end


  defp _get_state(map, topic) do
    case  Map.fetch(map, topic) do
      {:ok, list}->
        list
      :error->
        []
    end
  end

  defp _put_state(map, topic, elem) do
    case  Map.fetch(map, topic) do
      {:ok, list}->
        new_list = _put(list, elem)
        Map.replace(map, topic, new_list)
      :error->
        Map.put(map, topic, [elem])
    end
  end


  defp _put([], value), do: [value|[]]
  defp _put([h|t], value), do: [h|_put(t, value)]
end
