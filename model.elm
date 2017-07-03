module Model exposing (Model, Velocity, toSvgUnits, playArea, timePerMove)

import Time exposing (Time, second)


type alias Model =
    { headPosition : Position
    , velocity : Velocity
    , timeSinceMove : Time
    }


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
