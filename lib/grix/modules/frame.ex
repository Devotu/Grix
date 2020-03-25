defmodule Grix.Frame do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Frame

  defstruct id: "", name: ""

  def get(id) do
    query = """
    MATCH
      (f:Frame)
    WHERE
      f.id = "#{id}"
    RETURN
      {
        id: f.id,
        name: f.name
      } AS frame
    """

    Database.get(query)
    |> nodes_to_frames
    |> Helpers.return_expected_single
  end


  #Helpers
  defp nodes_to_frames(nodes) do
    Enum.map(nodes, &node_to_frame/1)
  end

  defp node_to_frame(node) do
    frame_map = Helpers.atomize_keys(node["frame"])
    struct(Frame, frame_map)
  end
end
