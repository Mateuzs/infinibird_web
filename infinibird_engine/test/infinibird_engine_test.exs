defmodule InfinibirdEngineTest do
  use ExUnit.Case
  doctest InfinibirdEngine

  test "greets the world" do
    assert InfinibirdEngine.hello() == :world
  end
end
