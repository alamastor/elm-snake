module Snake exposing (Snake, TailSegment(TailSegment), toList)

import Position
    exposing
        ( Direction
            ( Up
            , Down
            , Left
            , Right
            )
        , Position
        )


type alias Snake =
    { position : Position
    , next : Maybe TailSegment
    }


type TailSegment
    = TailSegment
        { directionFromParent : Direction
        , next : Maybe TailSegment
        }


toList : Snake -> List Position
toList snake =
    snake.position :: (maybeTailList snake.position snake.next)


maybeTailList : Position -> Maybe TailSegment -> List Position
maybeTailList parentPosition tailSegment =
    tailSegment
        |> Maybe.map (tailList parentPosition)
        |> Maybe.withDefault []


tailList : Position -> TailSegment -> List Position
tailList parentPosition (TailSegment tailSegment) =
    let
        position =
            Position.movePosition tailSegment.directionFromParent parentPosition
    in
        position :: maybeTailList position tailSegment.next
