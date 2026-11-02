# Слайд 08. Task для отдельного вычисления, Agent для простого состояния.
# Запуск: elixir 08_task_agent.exs

IO.puts("Слайд 08 — Task и Agent")

task = Task.async(fn -> 2 + 2 end)
IO.puts("Task.await вернул: #{Task.await(task, 2_000)}")

{:ok, agent} = Agent.start_link(fn -> 0 end)

try do
  initial = Agent.get(agent, & &1)
  IO.puts("Начальное состояние Agent: #{initial}")

  :ok = Agent.update(agent, &(&1 + 1))
  :ok = Agent.update(agent, &(&1 + 1))

  IO.puts("Новое состояние Agent: #{Agent.get(agent, & &1)}")
after
  Agent.stop(agent)
end
