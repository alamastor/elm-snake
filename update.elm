module Update exposing (update)

import Time exposing (Time)
import Model exposing (Model)
import Messages exposing (Msg(NoOp, FrameMsg, KeyMsg, NewDinner))
import Position exposing (Position, Direction(..))
import Snake exposing (Snake, TailSegment(TailSegment))
import Constants exposing (playArea)
import Commands


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FrameMsg diff ->
            if model.movement.timeSinceMove + diff >= Constants.timePerMove then
                moveUpdate
                    (model.movement.timeSinceMove
                        + diff
                        + -Constants.timePerMove
                    )
                    model
            else
                ( { model
                    | movement =
                        updateTimeSinceMove (model.movement.timeSinceMove + diff)
                            model.movement
                  }
                , Cmd.none
                )

        KeyMsg code ->
            case code of
                37 ->
                    ( { model | movement = turn Left model.movement }, Cmd.none )

                38 ->
                    ( { model | movement = turn Up model.movement }, Cmd.none )

                39 ->
                    ( { model | movement = turn Right model.movement }, Cmd.none )

                40 ->
                    ( { model | movement = turn Down model.movement }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NewDinner position ->
            ( { model | dinner = position }, Cmd.none )


moveUpdate : Time -> Model -> ( Model, Cmd Msg )
moveUpdate timeRemainder model =
    let
        movedSnake =
            (moveSnake model.movement.direction model.snake)
    in
        if positionsCollide model.dinner movedSnake.position then
            ( { snake = growSnake model.movement movedSnake
              , movement =
                    model.movement
                        |> updateTimeSinceMove timeRemainder
                        |> updateTurnDone False
              , dinner = model.dinner
              }
            , Commands.randomDinner
            )
        else
            ( { snake = movedSnake
              , movement =
                    model.movement
                        |> updateTimeSinceMove timeRemainder
                        |> updateTurnDone False
              , dinner = model.dinner
              }
            , Cmd.none
            )


positionsCollide : Position -> Position -> Bool
positionsCollide a b =
    a.x == b.x && a.y == b.y


turn : Direction -> Model.Movement -> Model.Movement
turn direction movement =
    if turnAllowed direction movement then
        movement |> updateDirection direction |> updateTurnDone True
    else
        movement


turnAllowed : Direction -> Model.Movement -> Bool
turnAllowed direction movement =
    if movement.turnDone then
        False
    else
        case direction of
            Up ->
                if movement.direction == Left || movement.direction == Right then
                    True
                else
                    False

            Down ->
                if movement.direction == Left || movement.direction == Right then
                    True
                else
                    False

            Left ->
                if movement.direction == Down || movement.direction == Up then
                    True
                else
                    False

            Right ->
                if movement.direction == Down || movement.direction == Up then
                    True
                else
                    False


updateDirection : Direction -> Model.Movement -> Model.Movement
updateDirection direction movement =
    { movement | direction = direction }


updateTurnDone : Bool -> Model.Movement -> Model.Movement
updateTurnDone bool movement =
    { movement | turnDone = bool }


moveSnake : Direction -> Snake -> Snake
moveSnake direction snake =
    { position = Position.movePosition direction snake.position
    , next =
        flowDirectionMaybe
            (Position.reverseDirection
                direction
            )
            snake.next
    }


growSnake : Model.Movement -> Snake -> Snake
growSnake movement snake =
    case snake.next of
        Just next ->
            ({ snake | next = Just (growTail next) })

        Nothing ->
            { snake
                | next =
                    Just
                        (TailSegment
                            { directionFromParent =
                                Position.reverseDirection
                                    movement.direction
                            , next = Nothing
                            }
                        )
            }


growTail : TailSegment -> TailSegment
growTail (TailSegment tailSegment) =
    case tailSegment.next of
        Just next ->
            (TailSegment
                { tailSegment
                    | next =
                        Just
                            (growTail
                                next
                            )
                }
            )

        Nothing ->
            (TailSegment
                { tailSegment
                    | next =
                        Just
                            (TailSegment
                                { directionFromParent =
                                    tailSegment.directionFromParent
                                , next = Nothing
                                }
                            )
                }
            )


flowDirectionMaybe : Direction -> Maybe TailSegment -> Maybe TailSegment
flowDirectionMaybe direction tailSegment =
    Maybe.map (flowDirection direction) tailSegment


flowDirection : Direction -> TailSegment -> TailSegment
flowDirection direction (TailSegment tailSegment) =
    TailSegment
        { directionFromParent = direction
        , next =
            (flowDirectionMaybe
                (tailSegment.directionFromParent)
                (tailSegment.next)
            )
        }


updateTimeSinceMove : Time -> Model.Movement -> Model.Movement
updateTimeSinceMove time movement =
    { movement | timeSinceMove = time }
