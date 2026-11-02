# Слайд 11. OTP-приложение: Application, Supervisor, дочерние процессы.
# Запуск: elixir 11_otp_supervision_tree.exs
# Полноценное OTP Application (mix run) лежит в каталоге otp_project/.

defmodule NL2026.P03.DemoApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Agent, fn -> %{requests: 0} end},
      Task.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

IO.puts("Слайд 11 — Дерево OTP")

# В учебном .exs вызываем callback Application.start/2 напрямую;
# для настоящего автоматического запуска используйте otp_project/.
{:ok, root_supervisor} = NL2026.P03.DemoApplication.start(:normal, [])

try do
  children = Supervisor.which_children(root_supervisor)
  IO.inspect(Enum.map(children, fn {id, _pid, _type, _modules} -> id end),
    label: "Дочерние компоненты Supervisor")

  agent_pid =
    case List.keyfind(children, Agent, 0) do
      {Agent, pid, :worker, _} when is_pid(pid) -> pid
      _ -> raise "Agent отсутствует в дереве"
    end

  Agent.update(agent_pid, &Map.update!(&1, :requests, fn count -> count + 1 end))
  IO.inspect(Agent.get(agent_pid, & &1), label: "Состояние Agent внутри OTP-дерева")
after
  Supervisor.stop(root_supervisor)
end
