# Помощник для слайда 14. Загрузите в IEx на отдельном узле:
#   iex --sname receiver --cookie nl2026 -r 14_remote_receiver.exs
# Затем на втором узле запускайте 14_distributed_nodes.exs с --remote.

defmodule NL2026.P03.RemoteReceiver do
  def start do
    pid = spawn(fn -> loop() end)
    Process.register(pid, :nl2026_worker)
    pid
  end

  defp loop do
    receive do
      {:ping, from} ->
        send(from, {:pong, node()})
        loop()

      :stop ->
        :ok

      _other ->
        loop()
    end
  end
end

IO.puts("Демонстрационный получатель на узле #{inspect(Node.self())}")
IO.puts("Зарегистрирован как :nl2026_worker")
NL2026.P03.RemoteReceiver.start()
