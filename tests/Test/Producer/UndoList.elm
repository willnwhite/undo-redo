module Test.Producer.UndoList exposing (undolist)

import Check.Producer exposing (Producer)
import UndoList exposing (UndoList, Msg(..))
import UndoList.Random as Random
import UndoList.Shrink as Shrink
import Random
import Random.Extra exposing (flatMap2)


undolist : Producer state -> Producer (UndoList state)
undolist { generator, shrinker } =
    let
        gen =
            flatMap2 (\p f -> Random.undolist p f generator)
                (Random.int 0 100)
                (Random.int 0 100)

        shr =
            Shrink.undolist shrinker
    in
        Producer gen shr
