defmodule Grix.Helpers.Database do
  alias Bolt.Sips, as: Bolt

  def create_and_return(query, guid) do
    run_and_return(query)
    |> check_result_id(guid)
  end

  def get(query) do
    run_and_return(query)
  end

  def run(query) do
    IO.inspect(query, label: "Running\n")
    Bolt.query!(Bolt.conn, query)
    {:ok}
  end

  def run_and_return(query) do
    IO.inspect(query, label: "Running\n")
    Bolt.query!(Bolt.conn, query)
    |> IO.inspect(label: "Result:\n")
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


  def to_safe_json(nil), do: ""
  def to_safe_json(json_string) when is_bitstring(json_string) do
    String.replace(json_string, ~s("), "--")
  end
  def to_safe_json(_), do: ""



  def from_safe_json(nil), do: ""
  def from_safe_json(json_string) when is_bitstring(json_string) do
    String.replace(json_string, "--", ~s("))
  end
  def from_safe_json(_), do: ""


  def generate_id(base) do
    base
      |> String.replace(" ", "")
      |> String.downcase()
  end

  def convert_to_label(base) do
    base
      |> String.replace(" ", "")
      |> String.replace("-", "")
      |> String.downcase()
      |> String.capitalize()
  end

  def convert_to_name(base) do
    base
      |> String.capitalize()
  end

  def generate_in(list) do
    list_string = list
    |> Enum.map(&enquote/1)
    |> Enum.join(", ")

    "IN [#{list_string}]"
  end

  defp enquote(string) do
    ~s("#{string}")
  end
end
