defmodule Grix.XWS do

  def parse(xws_string) do
    parsed_data = Poison.decode(~s(#{xws_string}))
    IO.inspect(parsed_data, label: "parsed")
  end
end
