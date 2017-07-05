module Main exposing (..)

import Html exposing (Html, program, button, div, text)
import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, fill)
import Model
    exposing
        ( Model
        , Position
        , Snake
        , TailSegment(TailSegment)
        , Direction(Up, Down, Left, Right)
        , toSvgUnits
        , playArea
        , reverseDirection
        )
import Messages exposing (Msg)
import Update exposing (update, init, movePosition)
import Subscriptions exposing (subscriptions)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ svg
            [ toSvgUnits playArea.width |> width
            , toSvgUnits playArea.height |> height
            ]
            ([ board, drawDinner model.dinner ]
                ++ drawSnake model.snake
            )
        ]


board : Svg Msg
board =
    rect
        [ toSvgUnits playArea.width
            |> width
        , toSvgUnits playArea.height |> height
        , fill "black"
        ]
        []


section : Position -> Svg Msg
section position =
    rect
        [ toSvgUnits position.x
            |> x
        , toSvgUnits position.y |> y
        , toSvgUnits 1 |> width
        , toSvgUnits 1 |> height
        , fill "white"
        ]
        []


drawSnake : Snake -> List (Svg Msg)
drawSnake snake =
    section snake.position :: (maybeDrawTail snake.position snake.next)


maybeDrawTail : Position -> Maybe TailSegment -> List (Svg Msg)
maybeDrawTail position tailSegment =
    Maybe.map (drawTail position) tailSegment
        |> Maybe.withDefault []


drawTail : Position -> TailSegment -> List (Svg Msg)
drawTail position (TailSegment tailSegment) =
    let
        thisPosition =
            movePosition tailSegment.directionFromParent position

        thisSegment =
            section thisPosition
    in
        thisSegment :: maybeDrawTail thisPosition tailSegment.next


drawDinner : Position -> Svg Msg
drawDinner position =
    rect
        [ toSvgUnits position.x
            |> x
        , toSvgUnits position.y |> y
        , toSvgUnits 1 |> width
        , toSvgUnits 1 |> height
        , fill "red"
        ]
        []
