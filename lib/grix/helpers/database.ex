defmodule Grix.Helpers.Database do
  alias Bolt.Sips, as: Bolt

  def create(query, guid) do
    run(query)
    |> check_result_id(guid)
  end

  def get(query) do
    run(query)
  end

  def run(query) do
    Bolt.query!(Bolt.conn, query)
  end

  def return_single_result_id(response) do
    %{results: results} = response
    [ row ] = results
    { created_id } = { row["id"] }
    created_id
  end


  def check_result_id(response, expected_id) do
    created_id = return_single_result_id(response)
    return_expected_matching_id(created_id, expected_id)
  end


  def return_expected_matching_id(created_id, generated_id) do
    case created_id == generated_id do
    :true ->
        { :ok, created_id }
    :false ->
        { :error, :insert_failure }
    end
  end
end
