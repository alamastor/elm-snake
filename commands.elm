module Commands exposing (randomDinner)

import Random
import Model exposing (playArea)
import Messages exposing (Msg(NewDinner))


randomDinner : Cmd Msg
randomDinner =
    Random.map2
        (\x y -> { x = x, y = y })
        (Random.int 0 (playArea.width - 1))
        (Random.int 0 (playArea.height - 1))
        |> Random.generate NewDinner
