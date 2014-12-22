defmodule Song do
  defstruct name: nil
end

defmodule SongRepresenter do
  use Kitsune.JSON

  property :title, as: :name
end
 
defmodule JSONTest do
  use ExUnit.Case

  setup do
    song = %Song{name: "Gin and Juice"}
    { :ok, song: song }
  end

  test "Transforms data to json", %{song: song} do   
    json = SongRepresenter.to_json(song)
    assert json == "{\"title\":\"Gin and Juice\"}"
  end

  test "Transforms data from json", %{song: song} do
    json = "{\"title\":\"Gin and Juice\"}"
    assert SongRepresenter.from_json(json, Song) == song
  end
end
