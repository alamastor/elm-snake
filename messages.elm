module Messages exposing (Msg(..))

import Time exposing (Time)
import Keyboard


type Msg
    = NoOp
    | FrameMsg Time
    | KeyMsg Keyboard.KeyCode
