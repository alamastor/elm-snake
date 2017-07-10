module Constants exposing (Unit, pixelsPerUnit, playArea, timePerMove)

import Time exposing (Time, second)


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
