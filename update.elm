module Update exposing (update, init)

import Model exposing (Model, Velocity, playArea)
import Messages exposing (Msg(NoOp, FrameMsg))
import Time exposing (Time)
import Debug exposing (log)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FrameMsg diff ->
            if Time.inSeconds model.timeSinceMove + Time.inSeconds diff >= 0.5 then
                ( model |> updatePosition model.velocity |> resetTimeSinceMove, Cmd.none )
            else
                ( { model | timeSinceMove = model.timeSinceMove + diff }, Cmd.none )


updatePosition : Velocity -> Model -> Model
updatePosition velocity model =
    { model
        | headPosition =
            { x = (model.headPosition.x + velocity.u) % playArea.width
            , y = (model.headPosition.y - velocity.v) % playArea.height
            }
    }


resetTimeSinceMove : Model -> Model
resetTimeSinceMove model =
    { model | timeSinceMove = 0 }


init : ( Model, Cmd Msg )
init =
    ( { headPosition = { x = 10, y = 10 }
      , velocity = { u = 0, v = 1 }
      , timeSinceMove = 0
      }
    , Cmd.none
    )
