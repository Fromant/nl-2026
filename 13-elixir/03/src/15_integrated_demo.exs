# Слайд 15. Совместная работа Supervisor, Task, Agent и сообщений.
# Запуск: elixir 15_integrated_demo.exs

IO.puts("Слайд 15 — Elixir + BEAM + OTP: итоговая схема")

# Task.Supervisor выполняет задачи в отдельных процессах;
# Agent хранит накопленный результат; верхний Supervisor управляет обоими.
children = [Task.Supervisor, {Agent, fn -> 0 end}]
{:ok, supervisor} = Supervisor.start_link(children, strategy: :one_for_one)

try do
  child_info = Supervisor.which_children(supervisor)

  {Task.Supervisor, task_supervisor, :supervisor, _} =
    List.keyfind(child_info, Task.Supervisor, 0)

  {Agent, agent_pid, :worker, _} = List.keyfind(child_info, Agent, 0)

  tasks =
    Enum.map(1..4, fn n ->
      Task.Supervisor.async_nolink(task_supervisor, fn -> n * n end)
    end)

  values = Enum.map(tasks, &Task.await(&1, 2_000))
  Enum.each(values, fn value -> Agent.update(agent_pid, &(&1 + value)) end)

  IO.inspect(values, label: "Результаты независимых Task")
  IO.puts("Сумма, сохранённая в Agent: #{Agent.get(agent_pid, & &1)}")
  IO.puts("Supervisor контролирует жизненный цикл Task.Supervisor и Agent.")
after
  Supervisor.stop(supervisor)
end
