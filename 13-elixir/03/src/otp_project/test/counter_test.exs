defmodule NL2026OTPDemo.CounterTest do
  use ExUnit.Case, async: true
  alias NL2026OTPDemo.Counter

  test "increment and get work on a private supervised process" do
    name = String.to_atom("counter_test_#{System.unique_integer([:positive])}")
    pid = start_supervised!({Counter, name: name})

    assert Counter.get(pid) == 0
    assert Counter.increment(pid) == 1
    assert Counter.get(pid) == 1
  end

  test "application supervisor starts a Task.Supervisor" do
    Application.ensure_all_started(:nl2026_otp_demo)
    children = Supervisor.which_children(NL2026OTPDemo.Supervisor)
    assert Enum.any?(children, fn {_id, pid, type, _} -> type == :supervisor and is_pid(pid) end)
  end
end
