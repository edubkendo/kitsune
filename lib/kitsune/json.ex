defmodule Kitsune.JSON do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import Kitsune.JSON
      @properties []
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

  defmacro __before_compile__(env) do
    quote do
      def to_json(struct) do
        map = for {label, as} <- @properties, into: %{} do
          { label, Map.get(struct, as) }
        end
        {:ok, json} = Poison.encode(map)
        json
      end

      def from_json(json, mod) do
        {:ok, decoded} = Poison.decode(json)
        map = for {label, as} <- @properties, into: %{} do
          { as, Map.get(decoded, Atom.to_string(label)) }
        end
        struct(mod, map)
      end
    end
  end
end
