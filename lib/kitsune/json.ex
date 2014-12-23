defmodule Kitsune.JSON do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import Kitsune.JSON
      @properties []
      @collections []
      @before_compile Kitsune.JSON
    end
  end

  @doc """
  Adds a single property to the eventual json output.

  ## Examples

      defmodule Person do
        defstruct name: nil, age: nil
      end

      defmodule PersonRepresenter do
        use Kitsune.JSON

        property :name
        property :age
      end

      person = %Person{name: "Nikki", age: 18}
      PersonRepresenter.to_json(person)
      #=> "{\"name\":\"Nikki\",\"age\":18}"

      json = "{\"name\":\"Nikki\",\"age\":18}"
      PersonRepresenter.from_json(json, Person)
      #=> %Person{ name: "Nikki", age: 18 }

      defmodule Song do
        defstruct name: nil
      end

      defmodule SongRepresenter do
        use Kitsune.JSON

        property :title, as: :name
      end

      song = %Song{name: "Gin and Juice"}
      SongRepresenter.to_json(song)
      #=> "{\"title\":\"Gin and Juice\"}"

      json = "{\"title\":\"Gin and Juice\"}"
      SongRepresenter.from_json(json, Song)
      #=> %Song{name: "Gin and Juice"}

  """
  defmacro property(label, opts \\ []) do
    as = Keyword.get(opts, :as, label)
    quote do
      @properties [{unquote(label), unquote(as)}|@properties]
    end
  end

  @doc """
  Nest a collection of other representations in the output.

  ## Examples

      defmodule Album do
        defstruct name: nil, songs: []
      end

      defmodule AlbumRepresenter do
        use Kitsune.JSON

        property :name
        collection :songs, extend: SongRepresenter
      end

      album = %Album{name: "Doggystyle", songs: [song, %Song{name: "Lodi Dodi"}]}
      AlbumRepresenter.to_json(album)
      #=> "{\"name\":\"Doggystyle\",\"songs\":[{\"title\":\"Gin and Juice\"},{\"title\":\"Lodi Dodi\"}]}"

      json = "{\"name\":\"Doggystyle\",\"songs\":[{\"title\":\"Gin and Juice\"},{\"title\":\"Lodi Dodi\"}]}"
      AlbumRepresenter.from_json(json, Album)
      #=> %Album{name: "Doggystyle", songs: [%Song{name: "Gin and Juice"}, %Song{name: "Lodi Dodi"}]}

  """
  defmacro collection(label, opts \\ []) do
    as = Keyword.get(opts, :as, label)
    extend = Keyword.get(opts, :extend)
    from = Keyword.get(opts, :from)
    quote do
      @collections [%{
                      label: unquote(label),
                      as: unquote(as),
                      extend: unquote(extend),
                      from: unquote(from)
                     } | @collections ]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def to_json(struct) do
        map =  _map_from_collections(struct)
            |> _map_from_properties(struct)
        {:ok, json} = Poison.encode(map)
        json
      end

      defp _map_from_collections(struct) do
        for %{label: label, as: as, extend: extend} <- @collections, into: %{} do
          { label, Enum.map( Map.get(struct, as), fn(x) ->
            extend.to_json(x) |> _unjson
          end) }
        end
      end

      defp _map_from_properties(map, struct) do
        for {label, as} <- @properties, into: map do
          { label, Map.get(struct, as) }
        end
      end

      defp _unjson(json) do
        {:ok, decoded} = Poison.decode(json)
        decoded
      end

      def from_json(json, mod) do
        decoded = _unjson(json)
        map = for {label, as} <- @properties, into: %{} do
          { as, Map.get(decoded, Atom.to_string(label)) }
        end

        collections = for %{label: label, as: as, extend: extend, from: from} <- @collections, into: %{} do
          { as,
            Map.get(decoded, Atom.to_string(label))
            |> Enum.map(fn(x) ->
              {:ok, struct_json} = Poison.encode(x)
              extend.from_json(struct_json, from)
            end)
          }
        end

        Enum.map(@collections, fn(c) ->
          map = Map.pop(map, Atom.to_string(c[:label]))
        end)

        map = Map.merge(map, collections)

        struct(mod, map)
      end
    end
  end
end
