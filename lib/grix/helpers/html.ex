defmodule Grix.Helpers.Html do

  def as_options(list) do
    list
    |> Enum.map(&{&1.name, &1.id})
    |> IO.inspect(label: "Soon to be options")
  end
end
