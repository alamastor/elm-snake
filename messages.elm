module Messages exposing (Msg(..))

import Time exposing (Time)


type Msg
    = NoOp
    | FrameMsg Time
