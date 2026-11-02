# Слайд 09. GenServer: start_link, init, handle_call и handle_cast.
# Запуск: elixir 09_genserver.exs

defmodule NL2026.P03.Counter do
  use GenServer

  def start_link(initial), do: GenServer.start_link(__MODULE__, initial)
  def get(pid), do: GenServer.call(pid, :get)
  def increment(pid), do: GenServer.cast(pid, :inc)

  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}

  @impl true
  def handle_cast(:inc, state), do: {:noreply, state + 1}
end

IO.puts("Слайд 09 — GenServer-счётчик")
{:ok, counter} = NL2026.P03.Counter.start_link(0)

try do
  IO.puts("До: #{NL2026.P03.Counter.get(counter)}")
  :ok = NL2026.P03.Counter.increment(counter)
  # Сообщения от одного клиента одному серверу упорядочены.
  IO.puts("После: #{NL2026.P03.Counter.get(counter)}")
after
  GenServer.stop(counter)
end
