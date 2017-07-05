module Messages exposing (Msg(..))

import Time exposing (Time)
import Keyboard
import Model exposing (Position)


type Msg
    = NoOp
    | FrameMsg Time
    | KeyMsg Keyboard.KeyCode
    | NewDinner Position
