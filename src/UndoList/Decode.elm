module UndoList.Decode exposing (undolist, msg)

{-| Decode UndoList submodule.

Provides JSON decoders for Timelines and UndoList Messages.

# Decoders
@docs undolist, msg
-}

import UndoList exposing (UndoList, Msg(..))
import Json.Decode as Json exposing (Decoder)


{-| Decode an undo-list given a decoder of state.
-}
undolist : Decoder state -> Decoder (UndoList state)
undolist state =
    Json.map3 UndoList
        (Json.field "past" (Json.list state))
        (Json.field "present" state)
        (Json.field "future" (Json.list state))


{-| Decode an undo-list msg given a decoder of messages.
-}
msg : Decoder msg -> Decoder (Msg msg)
msg decoder =
    let
        unionDecoder =
            Json.string
                |> Json.map decodeMsgString
                |> Json.andThen fromResult
    in
        Json.oneOf
            [ unionDecoder
            , Json.map New (Json.field "New" decoder)
            ]


fromResult : Result String a -> Json.Decoder a
fromResult result =
    case result of
        Ok val ->
            Json.succeed val

        Err reason ->
            Json.fail reason


decodeMsgString : String -> Result String (Msg msg)
decodeMsgString str =
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
