defmodule TcpBroker.Server do

  use GenServer
  require Logger

  def start_link([port]) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    accept(port)
    {:ok, []}
  end

  def accept(port) do
    spawn(fn->listen(port)end)
  end


  def listen(port) do
    case :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true]) do
      {:ok, socket} ->
        Logger.info("Listening in port: #{port}")

        loop_accept(socket)
      {:error, reason} ->
        Logger.error("Could not listen: #{reason}")
    end
  end


  def loop_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Socket is connected on port #{inspect(client)}")

    spawn fn->
      Process.flag(:trap_exit, true)
      serve(client)
    end
    loop_accept(socket)
  end

  defp serve(socket) do
    case :gen_tcp.recv(socket, 2) do
      {:ok, data}->

        serve(socket)
      {:error, reason}->
        Logger.info("Socket terminating: #{reason}")
    end
  end

end
