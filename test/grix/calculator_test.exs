defmodule Grix.CalculatorTest do
  use ExUnit.Case
  alias Grix.Helpers.Calculator

  test "sum list of numbers" do
    assert 9 == Calculator.sum([2,7,0])
    assert 20 == Calculator.sum([-2,7,0,10,3,2])
  end

  test "count average" do
    assert 3.0 == Calculator.average([2,7,0])
    assert 2.5 == Calculator.average([2,7,0,1])
  end

  test "percentage" do
    assert 25 == Calculator.percentage(25, 100)
    assert 50 == Calculator.percentage(150, 300)
    assert 200  == Calculator.percentage(44, 22)
    assert 33.3 == Calculator.percentage(1, 3)
  end
end
