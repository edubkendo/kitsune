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
      #=> {:ok, "{\"name\":\"Nikki\",\"age\":18}"}

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
        Poison.encode(map)
      end
    end
  end
end
