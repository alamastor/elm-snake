module Main exposing (..)

import Html exposing (Html, button, div, text)
import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, fill)


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { headPosition : Position }


model : Model
model =
    { headPosition =
        { x = 10
        , y = 10
        }
    }


type alias Position =
    { x : Int
    , y : Int
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



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    model



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
