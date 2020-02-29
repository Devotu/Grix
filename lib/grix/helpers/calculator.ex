defmodule Grix.Helpers.Calculator do

  def average([]) do
    0
  end


  def average(list_of_numbers) do
    sum(list_of_numbers) / Enum.count(list_of_numbers)
  end


  def sum(list_of_numbers) do
    Enum.reduce(list_of_numbers, 0, &(&1+&2))
  end


  @spec count(any) :: non_neg_integer
  def count(list) do
    Enum.count(list)
  end


  def percentage(0, _) do
    0
  end

  def percentage(_count, 0) do
    0
  end

  def percentage(count, base) do
    (count/base)*100
    |> Float.round(1)
  end
end
