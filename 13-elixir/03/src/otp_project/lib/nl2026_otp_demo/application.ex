defmodule NL2026OTPDemo.Application do
  @moduledoc """
  Настоящий OTP Application callback (Mix автоматически вызывает start/2).
  Дерево: Application -> Supervisor -> Counter + Task.Supervisor.
  """
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NL2026OTPDemo.Counter,
      {Task.Supervisor, name: NL2026OTPDemo.TaskSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: NL2026OTPDemo.Supervisor)
  end
end
