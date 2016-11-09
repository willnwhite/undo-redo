module Test.Producer.UndoList exposing (undolist)

import Check.Producer exposing (Producer)
import UndoList exposing (UndoList, Msg(..))
import UndoList.Random as ULRandom
import UndoList.Shrink as ULShrink
import Random
import Random.Extra as Random


undolist : Producer state -> Producer (UndoList state)
undolist { generator, shrinker } =
    let
        gen =
            Random.andThen2 (\p f -> ULRandom.undolist p f generator)
                (Random.int 0 100)
                (Random.int 0 100)

        shr =
            ULShrink.undolist shrinker
    in
        Producer gen shr
