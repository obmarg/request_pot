defmodule RequestPot.PotSupervisorTest do
  use ExUnit.Case

  alias RequestPot.{PotSupervisor, PotServer}

  setup do
    {:ok, pid} = PotSupervisor.start_link([])

    {:ok, %{pid: pid}}
  end

  test "can add a public pot", %{pid: pid} do
    {:ok, pot_info} = PotSupervisor.add_pot(false, pid)
    refute pot_info.private
    assert PotServer.exists?(pot_info.name)
    assert PotServer.info(pot_info.name) == pot_info
  end

  test "can add a private pot", %{pid: pid} do
    {:ok, pot_info} = PotSupervisor.add_pot(true, pid)
    assert pot_info.private
    assert PotServer.exists?(pot_info.name)
    assert PotServer.info(pot_info.name) == pot_info
  end
end
