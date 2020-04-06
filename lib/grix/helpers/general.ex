defmodule Grix.Helpers.General do

  def generate_guid() do
    1..4
    |> Enum.map( fn(_x) -> generate_lower_case_sequence(4) end )
    |> Enum.join("-")
  end


  def generate_lower_case_sequence(len) do
    1..len
    |> Enum.map( fn(_x) -> <<Enum.random(97..122)>> end )
    |> Enum.join
  end


  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end


  def return_expected_single(list) do
    case Enum.count list do
      1 ->
        Enum.fetch(list, 0)
      0 ->
        { :error, :not_found}
      _ ->
        { :error, :invalid_request}
    end
  end


  def return_as_tuple({:error, msg}) do
    {:error, msg}
  end

  def return_as_tuple(item) do
    {:ok, item}
  end


  def return_id(%{} = map) do
    map.id
  end


  def pipe_update_map(map, key, value) do
    %{map | key => value}
  end


  def without_ok({:ok, value}), do: value
  def without_ok(other), do: other
end
