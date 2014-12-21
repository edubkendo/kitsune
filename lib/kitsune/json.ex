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

  """
  defmacro property(label) do
    quote do
      @properties [unquote(label)|@properties]
    end
  end

  defmacro __before_compile__(env) do
    quote do
      def to_json(struct) do
        map = for p <- @properties, into: %{} do
          { p, Map.get(struct, p) }
        end
        {:ok, json} = Poison.encode(map)
        json
      end

      def from_json(json, mod) do
        {:ok, decoded} = Poison.decode(json)
        map = for p <- @properties, into: %{} do
          { p, Map.get(decoded, Atom.to_string(p)) }
        end
        struct(mod, map)
      end
    end
  end
end
