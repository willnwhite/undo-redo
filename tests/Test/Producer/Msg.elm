module Test.Producer.Msg exposing (msg)

import Check.Producer exposing (Producer)
import UndoList exposing (Msg(..))
import UndoList.Random as Random
import UndoList.Shrink as Shrink


msg : Producer msg -> Producer (Msg msg)
msg { generator, shrinker } =
    let
        gen =
            Random.msg generator

        shr =
            Shrink.msg shrinker
    in
        Producer gen shr
