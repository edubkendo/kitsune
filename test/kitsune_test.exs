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

  setup do
    person = %Person{name: "Nikki", age: 18}
    { :ok, person: person }
  end

  test "Transforms data to json", %{person: person} do   
    {:ok, json} = PersonRepresenter.to_json(person)
    assert json == "{\"name\":\"Nikki\",\"age\":18}"
  end

  test "Transforms data from json", %{person: person} do
    json = "{\"name\":\"Nikki\",\"age\":18}"
    assert PersonRepresenter.from_json(json, Person) == person
  end
end
