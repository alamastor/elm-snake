module Update exposing (update, init, movePosition)

import Time exposing (Time)
import Model
    exposing
        ( Model
        , Velocity
        , Movement
        , Direction(Up, Down, Left, Right)
        , Snake
        , TailSegment(TailSegment)
        , Position
        , reverseDirection
        , playArea
        , timePerMove
        )
import Messages exposing (Msg(NoOp, FrameMsg, KeyMsg, NewDinner))
import Commands
import Debug


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FrameMsg diff ->
            if model.movement.timeSinceMove + diff >= timePerMove then
                moveUpdate (model.movement.timeSinceMove + diff + -timePerMove) model
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


turn : Direction -> Movement -> Movement
turn direction movement =
    if turnAllowed direction movement then
        movement |> updateDirection direction |> updateTurnDone True
    else
        movement


turnAllowed : Direction -> Movement -> Bool
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


updateDirection : Direction -> Movement -> Movement
updateDirection direction movement =
    { movement | direction = direction }


updateTurnDone : Bool -> Movement -> Movement
updateTurnDone bool movement =
    { movement | turnDone = bool }


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


moveSnake : Direction -> Snake -> Snake
moveSnake direction snake =
    { position = movePosition direction snake.position
    , next = flowDirectionMaybe (reverseDirection direction) snake.next
    }


growSnake : Movement -> Snake -> Snake
growSnake movement snake =
    case snake.next of
        Just next ->
            ({ snake | next = Just (growTail next) })

        Nothing ->
            { snake
                | next =
                    Just
                        (TailSegment
                            { directionFromParent = reverseDirection movement.direction
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
                                { directionFromParent = tailSegment.directionFromParent
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
        , next = (flowDirectionMaybe (tailSegment.directionFromParent) (tailSegment.next))
        }


updateTimeSinceMove : Time -> Movement -> Movement
updateTimeSinceMove time movement =
    { movement | timeSinceMove = time }


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
