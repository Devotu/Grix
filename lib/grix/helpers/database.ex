defmodule Grix.Helpers.Database do

  def run(query) do

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
