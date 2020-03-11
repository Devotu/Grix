defmodule Grix.XWS do

  def parse(xws_string) do
    parsed_data = Poison.decode(~s(#{xws_string}))
  end

  def is_valid(xws_string) do
    parse(xws_string)
    :ok
  end
end
