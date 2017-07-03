module Subscriptions exposing (subscriptions)

import AnimationFrame
import Model exposing (Model)
import Messages exposing (Msg(FrameMsg))


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs FrameMsg
