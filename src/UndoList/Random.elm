module UndoList.Random exposing (undolist, msg)

{-| Random UndoList Submodule.

Provides random undolist and undolist msg generators.

# Generators
@docs undolist, msg
-}

import UndoList exposing (UndoList, Msg(..))
import Random.Pcg as Random exposing (Generator)


{-| Random UndoList Generator constructor.
Given a generator of state, a length for the past, and a length for the future,
generate a random undolist of states.

    undolist pastLength futureLength generator
-}
undolist : Int -> Int -> Generator state -> Generator (UndoList state)
undolist pastLength futureLength generator =
    Random.map3 UndoList
        (Random.list pastLength generator)
        (generator)
        (Random.list futureLength generator)


{-| Generate random undolist msgs given an msg generator.

Generates msgs with the following probabilities:

- Reset  : 5%
- Forget : 5%
- Undo   : 30%
- Redo   : 30%
- New    : 30%
-}
msg : Generator msg -> Generator (Msg msg)
msg generator =
    Random.frequency
        [ ( 1, Random.constant Reset )
        , ( 1, Random.constant Forget )
        , ( 6, Random.constant Undo )
        , ( 6, Random.constant Redo )
        , ( 6, Random.map New generator )
        ]
