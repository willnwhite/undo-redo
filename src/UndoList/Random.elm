module UndoList.Random exposing (undolist, msg)
{-| Random UndoList Submodule.

Provides random undolist and undolist msg generators.

# Generators
@docs undolist, msg
-}


import UndoList     exposing (UndoList, Msg(..))
import Random       exposing (Generator, list, map, map3)
import Random.Extra exposing (frequency, constant)


{-| Random UndoList Generator constructor.
Given a generator of state, a length for the past, and a length for the future,
generate a random undolist of states.

    undolist pastLength futureLength generator
-}
undolist : Int -> Int -> Generator state -> Generator (UndoList state)
undolist pastLength futureLength generator =
  map3 UndoList
    (list pastLength generator)
    (generator)
    (list futureLength generator)


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
  frequency
    [ (1, constant Reset)
    , (1, constant Forget)
    , (6, constant Undo)
    , (6, constant Redo)
    , (6, map New generator)
    ] (constant Reset)
