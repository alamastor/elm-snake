module Model
    exposing
        ( Model
        , Position
        , Velocity
        , Snake
        , TailSegment(TailSegment)
        , Direction(Up, Down, Left, Right)
        , toSvgUnits
        , playArea
        , timePerMove
        , reverseDirection
        )

import Time exposing (Time, second)


type alias Model =
    { snake : Snake
    , movement : Direction
    , timeSinceMove : Time
    , dinner : Position
    }


type alias Snake =
    { position : Position
    , next : Maybe TailSegment
    }


type TailSegment
    = TailSegment
        { directionFromParent : Direction
        , next : Maybe TailSegment
        }


type Direction
    = Left
    | Right
    | Up
    | Down


reverseDirection : Direction -> Direction
reverseDirection direction =
    case direction of
        Left ->
            Right

        Right ->
            Left

        Up ->
            Down

        Down ->
            Up


type alias Position =
    { x : Int
    , y : Int
    }


type alias Velocity =
    { u : Int
    , v : Int
    }


pixelsPerUnit : Int
pixelsPerUnit =
    15


timePerMove : Time
timePerMove =
    0.125 * second


type alias Unit =
    Int


type alias Rectangle =
    { width : Unit
    , height : Unit
    }


playArea : Rectangle
playArea =
    { width = 21
    , height = 21
    }


toSvgUnits : Unit -> String
toSvgUnits units =
    units * pixelsPerUnit |> toString
