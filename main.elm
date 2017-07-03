module Main exposing (..)

import Html exposing (Html, program, button, div, text)
import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, fill)
import Model exposing (Model, toSvgUnits, playArea)
import Messages exposing (Msg)
import Update exposing (update, init)
import Subscriptions exposing (subscriptions)


main : Program Never Model Msg
main =
    program { init = init, view = view, update = update, subscriptions = subscriptions }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ svg [ toSvgUnits playArea.width |> width, toSvgUnits playArea.height |> height ]
            [ board
            , head model
            ]
        ]


board : Svg Msg
board =
    rect [ toSvgUnits playArea.width |> width, toSvgUnits playArea.height |> height, fill "black" ] []


head : Model -> Svg Msg
head model =
    rect [ toSvgUnits model.headPosition.x |> x, toSvgUnits model.headPosition.y |> y, toSvgUnits 1 |> width, toSvgUnits 1 |> height, fill "white" ] []
