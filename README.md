Kitsune
=======

>A kitsune is a shapeshifter, and usually when it reaches the age of 100 years, it learn the ability to take on a human form. Thus, they have to be a fox for a hundred years before it can shapeshift from a fox to a human and back again. It is also said that a kitsune can duplicate other human beings, in other words shapeshift into the look-a-likes of different people.

-- http://www.mythicalcreaturesguide.com/page/Kitsune

Kitsune is an Elixir library for transforming the representation of data inspired by [Representable](https://github.com/apotonick/representable/).


## Examples

### Properties

```elixir
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
```

If your property doesn't match the name of the key in the Struct, use `as`.

```elixir

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

```
### Collections

You can use collections to create collections of representations inside representations.

```elixir

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

```

## Other

- [Docs](http://hexdocs.pm/kitsune/)
