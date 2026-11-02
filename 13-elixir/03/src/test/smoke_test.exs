# Проверяет реальное выполнение учебных .exs-примеров отдельными запусками Elixir.
# Запуск: elixir test/smoke_test.exs

ExUnit.start()

defmodule NL2026.P03.SmokeTest do
  use ExUnit.Case, async: false

  @source_root Path.expand("..", __DIR__)
  @scripts [
    "02_concurrency_parallelism.exs",
    "03_beam_vm.exs",
    "04_spawn_pid.exs",
    "05_mailbox_receive.exs",
    "06_state_setter_getter.exs",
    "07_links_monitors.exs",
    "08_task_agent.exs",
    "09_genserver.exs",
    "10_supervisor.exs",
    "11_otp_supervision_tree.exs",
    "12_let_it_crash.exs",
    "13_memory_gc.exs",
    "14_distributed_nodes.exs",
    "15_integrated_demo.exs"
  ]

  for filename <- @scripts do
    test "работает #{filename}" do
      filename = unquote(filename)
      {output, exit_status} =
        System.cmd("elixir", [Path.join(@source_root, filename)],
          cd: @source_root,
          stderr_to_stdout: true
        )

      assert exit_status == 0, "Ошибка в #{filename}:\n#{output}"
      assert String.contains?(output, "Слайд"), "Нет ожидаемого вывода: #{filename}"
    end
  end
end
