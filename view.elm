module View exposing (view)

import Model exposing (Model)
import Html exposing (Html, button, div, text)
import Messages exposing (Msg)
import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, fill)
import Constants exposing (Unit, playArea)
import Position exposing (Position)
import Snake exposing (Snake, TailSegment(..))


toSvgUnits : Unit -> String
toSvgUnits units =
    units * Constants.pixelsPerUnit |> toString


view : Model -> Html Msg
view model =
    div []
        [ svg
            [ toSvgUnits playArea.width |> width
            , toSvgUnits playArea.height |> height
            ]
            ([ board ]
                ++ drawSnake model.snake
                ++ [ drawDinner model.dinner ]
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
    snake
        |> Snake.asList
        |> List.map section


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
