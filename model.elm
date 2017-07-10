module Model exposing (Model, Movement)

import Position exposing (Direction(Up, Down, Left, Right), Position)
import Snake exposing (Snake)
import Time exposing (Time, second)
import Constants exposing (Unit)


type alias Model =
    { snake : Snake
    , dinner : Position
    , movement : Movement
    }


type alias Movement =
    { direction : Direction
    , timeSinceMove : Time
    , turnDone : Bool
    }
