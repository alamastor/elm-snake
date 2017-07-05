module Update exposing (update, init, movePosition)

import Model
    exposing
        ( Model
        , Velocity
        , Direction(Up, Down, Left, Right)
        , playArea
        , timePerMove
        , Snake
        , TailSegment(TailSegment)
        , Position
        , reverseDirection
        )
import Messages exposing (Msg(NoOp, FrameMsg, KeyMsg))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FrameMsg diff ->
            if model.timeSinceMove + diff >= timePerMove then
                ( { snake = (moveSnake model.movement model.snake)
                  , movement = model.movement
                  , timeSinceMove = (model.timeSinceMove + diff + -timePerMove)
                  }
                , Cmd.none
                )
            else
                ( { model | timeSinceMove = model.timeSinceMove + diff }
                , Cmd.none
                )

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
    if model.movement == Left || model.movement == Right then
        { model | movement = Up }
    else
        model


turnDown : Model -> Model
turnDown model =
    if model.movement == Left || model.movement == Right then
        { model | movement = Down }
    else
        model


turnRight : Model -> Model
turnRight model =
    if model.movement == Up || model.movement == Down then
        { model | movement = Right }
    else
        model


turnLeft : Model -> Model
turnLeft model =
    if model.movement == Up || model.movement == Down then
        { model | movement = Left }
    else
        model


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


flowDirectionMaybe : Direction -> Maybe TailSegment -> Maybe TailSegment
flowDirectionMaybe direction tailSegment =
    Maybe.map (flowDirection direction) tailSegment


flowDirection : Direction -> TailSegment -> TailSegment
flowDirection direction (TailSegment tailSegment) =
    TailSegment
        { directionFromParent = direction
        , next = (flowDirectionMaybe (tailSegment.directionFromParent) (tailSegment.next))
        }


resetTimeSinceMove : Model -> Model
resetTimeSinceMove model =
    { model | timeSinceMove = 0 }


init : ( Model, Cmd Msg )
init =
    ( { snake = initSnake
      , movement = Up
      , timeSinceMove = 0
      }
    , Cmd.none
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
