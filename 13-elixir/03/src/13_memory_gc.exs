# Слайд 13. Собственная память процессов, локальный GC, structural sharing.
# Запуск: elixir 13_memory_gc.exs

IO.puts("Слайд 13 — Память BEAM и Garbage Collector")

old_list = Enum.to_list(1..1_000_000)
new_list = [0 | old_list]

IO.puts("Старая голова списка: #{hd(old_list)}")
IO.puts("Новая голова списка: #{hd(new_list)}")
IO.puts("Добавление [0 | old_list] имеет сложность O(1),")
IO.puts("потому что создаётся новый головной узел с ссылкой на старый хвост.")
IO.puts("Хвост нового списка совпадает по значению со старым: #{tl(new_list) == old_list}")

IO.inspect(Process.info(self(), :memory), label: "Память текущего процесса до GC")
:erlang.garbage_collect(self())
IO.inspect(Process.info(self(), :memory), label: "Память текущего процесса после GC")

# Важно: это не бенчмарк, а иллюстрация структурного разделения.
# Передача сообщений между процессами в общем случае может копировать данные.
