# Слайд 02. Конкурентность и параллелизм.
# Запуск: elixir 02_concurrency_parallelism.exs
# Task.async_stream запускает независимые задания с ограничением max_concurrency.

IO.puts("Слайд 02 — Конкурентность и параллелизм")
IO.puts("Планировщиков BEAM: #{System.schedulers_online()}")

tasks = 1..6

results =
  tasks
  |> Task.async_stream(
    fn number ->
      Process.sleep(20)
      number * number
    end,
    max_concurrency: 3,
    ordered: true,
    timeout: 2_000
  )
  |> Enum.map(fn
    {:ok, value} -> value
    {:exit, reason} -> raise "Task завершился: #{inspect(reason)}"
  end)

IO.inspect(results, label: "Квадраты чисел")
IO.puts("BEAM чередует процессы и может выполнять их на нескольких ядрах CPU.")
