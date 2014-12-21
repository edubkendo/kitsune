defmodule Person do
  defstruct name: nil, age: nil
end

defmodule PersonRepresenter do
  use Kitsune.JSON

  property :name
  property :age
end
 
defmodule KitsuneTest do
  use ExUnit.Case
  doctest Kitsune

  test "Transforms data to json" do   
    person = %Person{name: "Nikki", age: 18}
    {:ok, json} = PersonRepresenter.to_json(person)
    assert json == "{\"name\":\"Nikki\",\"age\":18}"
  end
end
