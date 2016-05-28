module UndoList.Encode exposing (undolist, msg)
{-| Encode UndoList submodule.

Provides JSON encoders for Timelines and UndoList Messages.

# Encoders
@docs undolist, msg

-}

import UndoList     exposing (UndoList, Msg(..))
import Json.Encode  exposing (Value, object, list, string)

{-| Encode an undolist of JSON values.
Best paired with the `map` function from UndoList.

    encodeUndoList stateEncoder  =
      UndoList.map stateEncoder >> undolist
-}
undolist : UndoList Value -> Value
undolist {past, present, future} =
  object
    [ ("past"   , list past   )
    , ("present", present     )
    , ("future" , list future )
    ]



{-| Encode an UndoList Msg of JSON values.
Best paired with the `mapMsg` function from UndoList.

    encodeMsg msgEncoder =
      UndoList.mapMsg msgEncoder >> msg
-}
msg : Msg Value -> Value
msg msg' =
  case msg' of
    Reset ->
      string "Reset"

    Redo ->
      string "Redo"

    Undo ->
      string "Undo"

    Forget ->
      string "Forget"

    New value ->
      object
        [ ("New", value) ]
