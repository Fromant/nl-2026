# Слайд 07. Двусторонняя связь Link и односторонний Monitor.
# Запуск: elixir 07_links_monitors.exs

IO.puts("Слайд 07 — Link и Monitor")

# Monitor: наблюдатель не падает при завершении наблюдаемого процесса.
child = spawn(fn -> Process.sleep(25); exit(:demo_failure) end)
ref = Process.monitor(child)

receive do
  {:DOWN, ^ref, :process, ^child, reason} ->
    IO.puts("Monitor получил :DOWN, причина: #{inspect(reason)}")
after
  2_000 -> raise "Не получено сообщение :DOWN"
end

# Link: обычно сигнал ошибки завершил бы связанный родительский процесс.
# Чтобы продемонстрировать связь безопасно, временно превращаем EXIT в сообщение.
old_trap_flag = Process.flag(:trap_exit, true)

try do
  linked = spawn_link(fn -> exit(:linked_failure) end)

  receive do
    {:EXIT, ^linked, reason} ->
      IO.puts("Link получил сигнал EXIT, причина: #{inspect(reason)}")
  after
    2_000 -> raise "Не получено сообщение EXIT"
  end
after
  Process.flag(:trap_exit, old_trap_flag)
end
