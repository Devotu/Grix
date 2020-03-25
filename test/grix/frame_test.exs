defmodule Grix.FrameTest do
  use ExUnit.Case
  alias Grix.Frame

  test "get Frame" do
    {:ok, frame} = Frame.get("t65xwing")
    assert frame.name == "T-65 X-Wing"
  end
end
