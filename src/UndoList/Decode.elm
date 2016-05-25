module UndoList.Decode exposing (undolist, action)
{-| Decode UndoList submodule.

Provides JSON decoders for Timelines and UndoList Actions.

# Decoders
@docs undolist, action
-}

import UndoList     exposing (UndoList, Action(..))
import Json.Decode  exposing (Decoder, (:=), list, string, object3, oneOf, customDecoder)

{-| Decode an undo-list given a decoder of state.
-}
undolist : Decoder state -> Decoder (UndoList state)
undolist state =
  object3 UndoList
    ("past"     := list state)
    ("present"  := state)
    ("future"   := list state)


{-| Decode an undo-list action given a decoder of actions.
-}
action : Decoder action -> Decoder (Action action)
action decoder =
  let
      unionDecoder =
        customDecoder string <|
          \str ->
            if      str == "Reset"  then Ok Reset
            else if str == "Redo"   then Ok Redo
            else if str == "Undo"   then Ok Undo
            else if str == "Forget" then Ok Forget
            else Err (str ++ " is not a valid undolist action")

  in
      oneOf
        [ unionDecoder
        , Json.Decode.map New ("New" := decoder)
        ]
