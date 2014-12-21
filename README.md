Kitsune
=======

>A kitsune is a shapeshifter, and usually when it reaches the age of 100 years, it learn the ability to take on a human form. Thus, they have to be a fox for a hundred years before it can shapeshift from a fox to a human and back again. It is also said that a kitsune can duplicate other human beings, in other words shapeshift into the look-a-likes of different people.

-- http://www.mythicalcreaturesguide.com/page/Kitsune

Kitsune is an Elixir library for transforming the representation of data.


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

