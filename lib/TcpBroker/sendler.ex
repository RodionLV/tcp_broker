defmodule TcpBroker.Sendler do

  require Logger

  @header "message"

  def accept(socket, topic) do
    Logger.info("type is sendler in topic: #{topic}")

    spawn_link(fn->
      loop(socket, topic)
    end)
  end


  def loop(socket, topic) do

    case :gen_tcp.recv(socket, byte_size(@header)) do
      {:ok, @header}->
        put_data(socket, topic)
        :gen_tcp.recv(socket, 0)
      {:ok, other}->
        {:ok, tail} = :gen_tcp.recv(socket, 0)
        Logger.error("uncorrect data: #{other<>tail}")
        :gen_tcp.send(socket, "Uncorrect packet\n")
    end



    loop(socket, topic)
  end


  defp put_data(socket, topic) do
    case read_to(socket, "#") do
      num->
        size = num
        |> String.trim()
        |> String.to_integer()

        {:ok, data} = :gen_tcp.recv(socket, size)

        message = data
        |> String.trim()

        Logger.info("put data: #{message} in topic #{topic}")
        TcpBroker.BlockingQueue.put(topic, message)
    end
  end


  def read_to(socket, to, text\\"") do
    {:ok, char} = :gen_tcp.recv(socket, 1)

    if char != to do
      read_to(socket, to, text<>char)
    else
      text
    end
  end


end
