# Слайд 05. Mailbox, selective receive, after.
# Запуск: elixir 05_mailbox_receive.exs

IO.puts("Слайд 05 — Mailbox и receive")

send(self(), {:ordinary, "сначала отправленное"})
send(self(), {:important, 42})

# receive может пропустить неподходящее сообщение и выбрать другое.
receive do
  {:important, value} -> IO.puts("Важное сообщение: #{value}")
after
  1_000 -> raise "Важное сообщение не получено"
end

IO.inspect(Process.info(self(), :message_queue_len), label: "Осталось в mailbox")

receive do
  {:ordinary, text} -> IO.puts("Старое сообщение: #{text}")
after
  1_000 -> raise "Обычное сообщение не получено"
end

receive do
  :never_arrives -> IO.puts("Не будет выполнено")
after
  0 -> IO.puts("after 0: подходящих сообщений нет, не ждём")
end
