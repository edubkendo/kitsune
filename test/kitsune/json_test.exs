defmodule Song do
  defstruct name: nil
end

defmodule SongRepresenter do
  use Kitsune.JSON

  property :title, as: :name
end

defmodule Album do
  defstruct name: nil, songs: []
end

defmodule AlbumRepresenter do
  use Kitsune.JSON

  property :name
  collection :songs, extend: SongRepresenter, from: Song
end

defmodule JSONTest do
  use ExUnit.Case

  setup do
    song = %Song{name: "Gin and Juice"}
    album = %Album{name: "Doggystyle", songs: [song, %Song{name: "Lodi Dodi"}]}
    { :ok, song: song, album: album }
  end

  test "Transforms data to json", %{song: song} do
    json = SongRepresenter.to_json(song)
    assert json == "{\"title\":\"Gin and Juice\"}"
  end

  test "Transforms data from json", %{song: song} do
    json = "{\"title\":\"Gin and Juice\"}"
    assert SongRepresenter.from_json(json, Song) == song
  end

  test "Collection to json", %{song: _song, album: album} do
    json = "{\"songs\":[{\"title\":\"Gin and Juice\"},{\"title\":\"Lodi Dodi\"}],\"name\":\"Doggystyle\"}"
    assert AlbumRepresenter.to_json(album) == json
  end

  test "Collection from json", %{song: _song, album: album} do
    json = "{\"songs\":[{\"title\":\"Gin and Juice\"},{\"title\":\"Lodi Dodi\"}],\"name\":\"Doggystyle\"}"
    assert AlbumRepresenter.from_json(json, Album) == album
  end
end
