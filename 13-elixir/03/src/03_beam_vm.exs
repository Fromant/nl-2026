# Слайд 03. Архитектура BEAM.
# Запуск: elixir 03_beam_vm.exs

IO.puts("Слайд 03 — Виртуальная машина BEAM")
IO.puts("Текущий процесс PID: #{inspect(self())}")
IO.puts("Количество процессов BEAM: #{:erlang.system_info(:process_count)}")
IO.puts("Планировщиков онлайн: #{System.schedulers_online()}")

info = Process.info(self(), [:memory, :message_queue_len, :reductions])
IO.inspect(info, label: "Состояние текущего процесса")

bytes = :erlang.memory(:total)
IO.puts("Общая память BEAM (байт): #{bytes}")

parent = self()
spawn(fn -> send(parent, {:beam_message, self()}) end)

receive do
  {:beam_message, pid} -> IO.puts("Сообщение от процесса: #{inspect(pid)}")
after
  1_000 -> raise "Процесс не ответил вовремя"
end
