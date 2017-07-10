module Position
    exposing
        ( Position
        , Direction(Up, Down, Left, Right)
        , reverseDirection
        , movePosition
        )

import Constants exposing (playArea)


type alias Position =
    { x : Int
    , y : Int
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


movePosition : Direction -> Position -> Position
movePosition direction position =
    case direction of
        Up ->
            { position | y = (position.y - 1) % playArea.height }

        Down ->
            { position | y = (position.y + 1) % playArea.height }

        Left ->
            { position | x = (position.x - 1) % playArea.width }

        Right ->
            { position | x = (position.x + 1) % playArea.width }
