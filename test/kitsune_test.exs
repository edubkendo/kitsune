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

  test "the truth" do   
    person = %Person{name: "Nikki", age: 18}
    PersonRepresenter.to_json(person)
  end
end
