module Init exposing (init)

import Model exposing (Model)
import Messages exposing (Msg)
import Position exposing (Direction(..))
import Commands
import Snake exposing (Snake, TailSegment(..))


init : ( Model, Cmd Msg )
init =
    ( { snake = initSnake
      , movement =
            { direction = Up
            , timeSinceMove = 0
            , turnDone = False
            }
      , dinner = { x = 0, y = 0 }
      }
    , Commands.randomDinner
    )


initSnake : Snake
initSnake =
    { position = { x = 10, y = 10 }
    , next =
        Just
            (TailSegment
                { directionFromParent = Down
                , next =
                    Just
                        (TailSegment
                            { directionFromParent = Down
                            , next = Nothing
                            }
                        )
                }
            )
    }
