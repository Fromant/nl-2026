defmodule NL2026OTPDemo.Counter do
  @moduledoc """
  Пример GenServer из OTP-приложения.
  Хранит числовое состояние. Данные внутри процесса не изменяются «на месте».
  """
  use GenServer

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, 0, name: name)
  end

  def increment(server \\ __MODULE__), do: GenServer.call(server, :increment)
  def get(server \\ __MODULE__), do: GenServer.call(server, :get)

  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:increment, _from, state), do: {:reply, state + 1, state + 1}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}
end
