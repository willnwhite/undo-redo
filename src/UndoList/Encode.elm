module UndoList.Encode exposing (undolist, msg)

{-| Encode UndoList submodule.

Provides JSON encoders for Timelines and UndoList Messages.

# Encoders
@docs undolist, msg

-}

import UndoList exposing (UndoList, Msg(..))
import Json.Encode as Json exposing (Value)


{-| Encode an undolist of JSON values.
Best paired with the `map` function from UndoList.

    encodeUndoList stateEncoder  =
      UndoList.map stateEncoder >> undolist
-}
undolist : UndoList Value -> Value
undolist { past, present, future } =
    Json.object
        [ ( "past", Json.list past )
        , ( "present", present )
        , ( "future", Json.list future )
        ]


{-| Encode an UndoList Msg of JSON values.
Best paired with the `mapMsg` function from UndoList.

    encodeMsg msgEncoder =
      UndoList.mapMsg msgEncoder >> msg
-}
msg : Msg Value -> Value
msg msg =
    case msg of
        Reset ->
            Json.string "Reset"

        Redo ->
            Json.string "Redo"

        Undo ->
            Json.string "Undo"

        Forget ->
            Json.string "Forget"

        New value ->
            Json.object [ ( "New", value ) ]
