module Model exposing (Model, Velocity, toSvgUnits, playArea)

import Time exposing (Time)


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
