# Слайд 10. Supervisor и стратегия :one_for_one.
# Запуск: elixir 10_supervisor.exs

defmodule NL2026.P03.RestartWorker do
  use GenServer

  def start_link(label), do: GenServer.start_link(__MODULE__, label)

  @impl true
  def init(label), do: {:ok, label}
end

defmodule NL2026.P03.SupervisorDemo do
  defp child_pid(supervisor) do
    case Supervisor.which_children(supervisor) do
      [{NL2026.P03.RestartWorker, pid, :worker, _}] when is_pid(pid) -> pid
      _ -> nil
    end
  end

  defp await_new_pid(supervisor, old_pid, attempts) when attempts > 0 do
    case child_pid(supervisor) do
      pid when is_pid(pid) and pid != old_pid -> pid
      _ ->
        Process.sleep(20)
        await_new_pid(supervisor, old_pid, attempts - 1)
    end
  end

  defp await_new_pid(_supervisor, _old_pid, 0) do
    raise "Supervisor не перезапустил рабочий процесс"
  end

  def run do
    children = [{NL2026.P03.RestartWorker, :worker}]
    {:ok, supervisor} = Supervisor.start_link(children, strategy: :one_for_one)

    try do
      old_pid = child_pid(supervisor)
      IO.puts("Worker стартовал: #{inspect(old_pid)}")
      Process.exit(old_pid, :kill)

      new_pid = await_new_pid(supervisor, old_pid, 100)
      IO.puts("После сбоя Supervisor запустил: #{inspect(new_pid)}")
      IO.puts("PID изменился: #{old_pid != new_pid}")
    after
      Supervisor.stop(supervisor)
    end
  end
end

IO.puts("Слайд 10 — Supervisor (:one_for_one)")
NL2026.P03.SupervisorDemo.run()
