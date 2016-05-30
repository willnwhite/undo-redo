module UndoListSuite exposing (tests)

import Check exposing (Claim, suite, claim, that, is, for, true)
import Check.Producer exposing (int, tuple)
import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, decodeValue)
import UndoList exposing (UndoList, Msg(..))
import UndoList.Decode as Decode
import UndoList.Encode as Encode
import Test.Producer.UndoList as Producer


tests : Claim
tests =
    suite "UndoList Suite"
        [ claim_encode_decode_inverse
        , claim_undolist_length_atleastone
        , claim_redo_does_not_change_length
        , claim_forget_produces_empty_past
        , claim_new_produces_empty_future
        , claim_new_adds_one_length_past
        , claim_undo_redo_inverse
        , claim_redo_undo_inverse
        , claim_new_then_undo_yields_same_present
        , claim_reset_equivalent_fresh_oldest
        ]



-- Claims


claim_encode_decode_inverse : Claim
claim_encode_decode_inverse =
    claim "Encoding and decoding are inverse operations"
        `that` encode_then_decode Encode.int Decode.int
        `is` Ok
        `for` Producer.undolist int


claim_undolist_length_atleastone : Claim
claim_undolist_length_atleastone =
    claim "The length of an undo list is at least one"
        `true` (\undolist -> UndoList.length undolist >= 1)
        `for` Producer.undolist int


claim_redo_does_not_change_length : Claim
claim_redo_does_not_change_length =
    claim "Redo does not change the length of an undo list"
        `that` (UndoList.redo >> UndoList.length)
        `is` UndoList.length
        `for` Producer.undolist int


claim_undo_does_not_change_length : Claim
claim_undo_does_not_change_length =
    claim "Undo does change the length of an undo list"
        `that` (UndoList.undo >> UndoList.length)
        `is` UndoList.length
        `for` Producer.undolist int


claim_forget_produces_empty_past : Claim
claim_forget_produces_empty_past =
    claim "After forgetting the past, the past of the undo list is empty"
        `that` (UndoList.forget >> UndoList.lengthPast)
        `is` always 0
        `for` Producer.undolist int


claim_new_produces_empty_future : Claim
claim_new_produces_empty_future =
    claim "Adding a new state yields an empty future"
        `that` (\( v, undolist ) -> UndoList.new v undolist |> UndoList.lengthFuture)
        `is` always 0
        `for` tuple ( int, Producer.undolist int )


claim_new_adds_one_length_past : Claim
claim_new_adds_one_length_past =
    claim "Adding a new state adds one element to the past"
        `that` (\( v, undolist ) -> UndoList.new v undolist |> UndoList.lengthPast)
        `is` (\( _, undolist ) -> UndoList.lengthPast undolist + 1)
        `for` tuple ( int, Producer.undolist int )


claim_undo_redo_inverse : Claim
claim_undo_redo_inverse =
    claim "Undo and redo are inverse operations"
        `that` undo_redo
        `is` identity
        `for` Producer.undolist int


claim_redo_undo_inverse : Claim
claim_redo_undo_inverse =
    claim "Redo and undo are inverse operations"
        `that` redo_undo
        `is` identity
        `for` Producer.undolist int


claim_new_then_undo_yields_same_present : Claim
claim_new_then_undo_yields_same_present =
    claim "Calling new then undo preserves the original present state"
        `that` (\( v, undolist ) -> UndoList.new v undolist |> UndoList.undo |> .present)
        `is` (\( _, undolist ) -> undolist.present)
        `for` tuple ( int, Producer.undolist int )


claim_reset_equivalent_fresh_oldest : Claim
claim_reset_equivalent_fresh_oldest =
    claim "Resetting an undo list is equivalent to creating an undo list with the oldest state"
        `that` UndoList.reset
        `is` fresh_oldest
        `for` Producer.undolist int



-- Helpers


encode_then_decode : (state -> Value) -> Decoder state -> UndoList state -> Result String (UndoList state)
encode_then_decode encoder decoder undolist =
    let
        encoded =
            undolist
                |> UndoList.map encoder
                |> Encode.undolist

        decoded =
            decodeValue (Decode.undolist decoder) encoded
    in
        decoded


undo_redo : UndoList state -> UndoList state
undo_redo undolist =
    if UndoList.hasPast undolist then
        UndoList.undo undolist
            |> UndoList.redo
    else
        undolist


redo_undo : UndoList state -> UndoList state
redo_undo undolist =
    if UndoList.hasFuture undolist then
        UndoList.redo undolist
            |> UndoList.undo
    else
        undolist


fresh_oldest : UndoList state -> UndoList state
fresh_oldest undolist =
    undolist.past
        |> List.reverse
        |> List.head
        |> Maybe.withDefault undolist.present
        |> UndoList.fresh
