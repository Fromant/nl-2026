# Слайд 04. spawn/1, self/0, PID, send/2.
# Запуск: elixir 04_spawn_pid.exs

IO.puts("Слайд 04 — Создание процессов")
parent = self()

pid =
  spawn(fn ->
    # self() внутри анонимной функции — PID дочернего процесса.
    send(parent, {:result, self(), 42})
  end)

IO.puts("PID родителя: #{inspect(parent)}")
IO.puts("PID потомка: #{inspect(pid)}")

receive do
  {:result, ^pid, value} ->
    IO.puts("Родитель получил результат: #{value}")
after
  1_000 ->
    raise "Время ожидания дочернего процесса истекло"
end
