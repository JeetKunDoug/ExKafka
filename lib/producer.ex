defmodule Kafka.Producer do
  use GenServer

  def init([host, port]) do
    {:ok, _socket} = :gen_tcp.connect(host, port, [:binary, {:packet, 0}])
  end

  def start_link(host, port) do
    GenServer.start_link(__MODULE__, [host, port])
  end

  def send_kafka_messsage(pid, message) do
    GenServer.call(pid, {:send_kafka_message, message})
  end

  def handle_call({:send_kafka_message, message}, _from, socket) do
    #TODO: create properly format/encode message for kafka
    :gen_tcp.send(socket, message)
    {status, data} = :gen_tcp.recv(socket, 0)
    {:reply, {status, data}, socket}
  end
end
