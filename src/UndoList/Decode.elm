module UndoList.Decode exposing (undolist, msg)

{-| Decode UndoList submodule.

Provides JSON decoders for Timelines and UndoList Messages.

# Decoders
@docs undolist, msg
-}

import UndoList exposing (UndoList, Msg(..))
import Json.Decode exposing (Decoder, (:=), list, string, object3, oneOf, customDecoder)


{-| Decode an undo-list given a decoder of state.
-}
undolist : Decoder state -> Decoder (UndoList state)
undolist state =
    object3 UndoList
        ("past" := list state)
        ("present" := state)
        ("future" := list state)


{-| Decode an undo-list msg given a decoder of messages.
-}
msg : Decoder msg -> Decoder (Msg msg)
msg decoder =
    let
        unionDecoder =
            customDecoder string
                <| \str ->
                    if str == "Reset" then
                        Ok Reset
                    else if str == "Redo" then
                        Ok Redo
                    else if str == "Undo" then
                        Ok Undo
                    else if str == "Forget" then
                        Ok Forget
                    else
                        Err (str ++ " is not a valid undolist message")
    in
        oneOf
            [ unionDecoder
            , Json.Decode.map New ("New" := decoder)
            ]
