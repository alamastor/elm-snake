module Update exposing (update, init)

import Model exposing (Model, Velocity, playArea, timePerMove)
import Messages exposing (Msg(NoOp, FrameMsg, KeyMsg))
import Time exposing (Time)
import Debug exposing (log)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FrameMsg diff ->
            if model.timeSinceMove + diff >= timePerMove then
                ( model |> updatePosition model.velocity |> resetTimeSinceMove, Cmd.none )
            else
                ( { model | timeSinceMove = model.timeSinceMove + diff }, Cmd.none )

        KeyMsg code ->
            case code of
                37 ->
                    ( turnLeft model, Cmd.none )

                38 ->
                    ( turnUp model, Cmd.none )

                39 ->
                    ( turnRight model, Cmd.none )

                40 ->
                    ( turnDown model, Cmd.none )

                _ ->
                    ( model, Cmd.none )


turnUp : Model -> Model
turnUp model =
    if model.velocity.v == 0 then
        { model | velocity = { u = 0, v = 1 } }
    else
        model


turnDown : Model -> Model
turnDown model =
    if model.velocity.v == 0 then
        { model | velocity = { u = 0, v = -1 } }
    else
        model


turnRight : Model -> Model
turnRight model =
    if model.velocity.u == 0 then
        { model | velocity = { u = 1, v = 0 } }
    else
        model


turnLeft : Model -> Model
turnLeft model =
    if model.velocity.u == 0 then
        { model | velocity = { u = -1, v = 0 } }
    else
        model


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
