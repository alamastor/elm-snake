module Commands exposing (randomDinner)

import Random
import Model exposing (playArea)
import Messages exposing (Msg(NewDinner))


randomDinner : Cmd Msg
randomDinner =
    Random.map2
        (\x y -> { x = x, y = y })
        (Random.int 0 playArea.width)
        (Random.int 0 playArea.height)
        |> Random.generate NewDinner
