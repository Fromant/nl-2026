# Слайд 06. Состояние внутри процесса; setter/getter через сообщения.
# Запуск: elixir 06_state_setter_getter.exs

defmodule NL2026.P03.StateServer do
  def start(initial_state) do
    spawn(fn -> loop(initial_state) end)
  end

  # Значение не изменяется «на месте»: следующий вызов получает новое state.
  defp loop(state) do
    receive do
      {:set, value} ->
        loop(value)

      {:get, from} ->
        send(from, {:value, state})
        loop(state)

      {:stop, from} ->
        send(from, :stopped)
        :ok
    end
  end
end

IO.puts("Слайд 06 — Setter/Getter с неизменяемыми значениями")
pid = NL2026.P03.StateServer.start(0)

# Отправлены одним клиентом: set поступает раньше get.
send(pid, {:set, 10})
send(pid, {:get, self()})

receive do
  {:value, value} -> IO.puts("Клиент получил состояние: #{value}")
after
  1_000 -> raise "Сервер состояния не ответил"
end

send(pid, {:stop, self()})
receive do
  :stopped -> IO.puts("Сервер состояния завершился штатно")
after
  1_000 -> raise "Сервер не завершился"
end
