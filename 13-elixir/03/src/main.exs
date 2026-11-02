# Единая точка запуска примеров для третьей презентации.
# Запуск: elixir main.exs (из любой директории)
#
# Не запускаем 14_remote_receiver.exs: это отдельный процесс на удалённом узле.

files = [
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

Enum.each(files, fn file ->
  IO.puts("\n========== #{file} ==========\n")
  Code.require_file(file, __DIR__)
end)

IO.puts("\nВсе локальные демонстрации завершены.")
IO.puts("Для реального OTP Application используйте подпроект otp_project/.")
