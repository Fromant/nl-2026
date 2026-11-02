# Слайд 14. Node, Erlang Distribution, сообщения между узлами.
# Без --remote безопасно показывает локальную информацию; второй узел не нужен.
#
# Демонстрация на ДВУХ терминалах (один хост, одинаковый cookie):
#   Терминал 1: iex --sname receiver --cookie nl2026 -r 14_remote_receiver.exs
#   Терминал 2: elixir --sname sender --cookie nl2026 14_distributed_nodes.exs --remote receiver@HOST
# Вместо HOST используйте имя хоста из Node.self() в терминале 1.

IO.puts("Слайд 14 — Распределённые узлы")
IO.puts("Текущий узел: #{inspect(Node.self())}")
IO.inspect(Node.list(), label: "Подключённые узлы")

case System.argv() do
  ["--remote", remote_node_name] ->
    if Node.alive?() do
      # Преобразование в атом безопасно для доверенного учебного аргумента.
      remote_node = String.to_atom(remote_node_name)
      IO.puts("Подключаемся к #{inspect(remote_node)}")

      if Node.connect(remote_node) == true do
        # PID знать необязательно: отправляем на зарегистрированное имя удалённого процесса.
        send({:nl2026_worker, remote_node}, {:ping, self()})

        receive do
          {:pong, ^remote_node} -> IO.puts("Получен ответ от узла #{inspect(remote_node)}")
        after
          3_000 -> raise "Удалённый процесс не ответил; проверьте 14_remote_receiver.exs"
        end
      else
        raise "Не удалось подключиться: проверьте имя узла, сеть и общий cookie"
      end
    else
      raise "Для межузлового режима запустите Elixir с --sname и --cookie"
    end

  [] ->
    IO.puts("Одиночный запуск: нет удалённого узла, сетевой обмен не выполняется.")
    IO.puts("Команды двухтерминальной демонстрации описаны в README.md.")

  _ ->
    raise "Использование: elixir 14_distributed_nodes.exs [--remote name@host]"
end
