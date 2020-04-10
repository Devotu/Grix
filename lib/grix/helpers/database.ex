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
    # |> IO.inspect(label: "Result:\n")
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
      |> trim()
      |> purgeNumbers()
      |> String.downcase()
  end

  def convert_to_label(base) do
    base
      |> trim()
      |> purgeNumbers()
      |> String.replace("-", "")
      |> String.downcase()
      |> String.capitalize()
  end

  def convert_to_name(base) do
    base
    |> recallNumbers()
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

  defp trim(string) do
    String.replace(string, " ", "")
  end

  def purgeNumbers(string) do
    string
    |> String.replace("1", "one")
    |> String.replace("2", "two")
    |> String.replace("3", "three")
    |> String.replace("4", "four")
    |> String.replace("5", "five")
    |> String.replace("6", "six")
    |> String.replace("7", "seven")
    |> String.replace("8", "eight")
    |> String.replace("9", "nine")
  end

  def recallNumbers(string) do
    string
    |> String.replace("one", "1")
    |> String.replace("two", "2")
    |> String.replace("three", "3")
    |> String.replace("four", "4")
    |> String.replace("five", "5")
    |> String.replace("six", "6")
    |> String.replace("seven", "7")
    |> String.replace("eight", "8")
    |> String.replace("nine", "9")
  end
end
