# Слайд 12. Let it crash: ошибка дочернего процесса и восстановление Supervisor.
# Запуск: elixir 12_let_it_crash.exs

defmodule NL2026.P03.CrashableWorker do
  use GenServer

  def start_link(_opts), do: GenServer.start_link(__MODULE__, 0)
  def increment(pid), do: GenServer.call(pid, :increment)
  def get(pid), do: GenServer.call(pid, :get)

  @impl true
  def init(value), do: {:ok, value}

  @impl true
  def handle_call(:increment, _from, state), do: {:reply, state + 1, state + 1}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}
end

defmodule NL2026.P03.LetItCrashDemo do
  defp worker_pid(supervisor) do
    case Supervisor.which_children(supervisor) do
      [{NL2026.P03.CrashableWorker, pid, :worker, _}] when is_pid(pid) -> pid
      _ -> nil
    end
  end

  defp wait_for_restart(supervisor, old_pid, left) when left > 0 do
    case worker_pid(supervisor) do
      pid when is_pid(pid) and pid != old_pid -> pid
      _ ->
        Process.sleep(20)
        wait_for_restart(supervisor, old_pid, left - 1)
    end
  end

  defp wait_for_restart(_, _, 0), do: raise("Не дождались перезапуска")

  def run do
    {:ok, supervisor} =
      Supervisor.start_link([{NL2026.P03.CrashableWorker, []}], strategy: :one_for_one)

    try do
      old_pid = worker_pid(supervisor)
      IO.puts("Состояние после инкремента: #{NL2026.P03.CrashableWorker.increment(old_pid)}")

      # Ошибка :kill не перехватывается дочерним процессом; Supervisor запускает его заново.
      Process.exit(old_pid, :kill)
      new_pid = wait_for_restart(supervisor, old_pid, 100)

      IO.puts("Новый PID: #{inspect(new_pid)}")
      IO.puts("Состояние нового процесса: #{NL2026.P03.CrashableWorker.get(new_pid)}")
      IO.puts("Вывод: обычный Supervisor восстанавливает процесс, но не его прежнее состояние.")
    after
      Supervisor.stop(supervisor)
    end
  end
end

IO.puts("Слайд 12 — Let it crash")
NL2026.P03.LetItCrashDemo.run()
