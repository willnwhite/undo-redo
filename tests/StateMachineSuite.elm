module StateMachineSuite exposing (..)

import Check exposing (Claim, suite, claim)
import Check.Producer exposing (int, tuple, list)
import UndoList exposing (UndoList, Msg(..))
import Test.Producer.UndoList as Producer
import Test.Producer.Msg as Producer


tests : Claim
tests =
    suite "State Machine Tests"
        [ claim_state_machine_length ]



-- Claims


claim_state_machine_length : Claim
claim_state_machine_length =
    claim "State Machine is consistent with respect to length"
        |> that state_machine_update
        |> is state_machine_step
        |> for (tuple ( list (Producer.msg int), Producer.undolist int ))



-- Helpers


state_machine_update : ( List (Msg Int), UndoList Int ) -> List ( Int, Int )
state_machine_update ( msgs, undolist ) =
    msgs
        |> List.map update
        |> pipe undolist
        |> List.map (\l -> ( UndoList.lengthPast l, UndoList.lengthFuture l ))


state_machine_step : ( List (Msg Int), UndoList Int ) -> List ( Int, Int )
state_machine_step ( msgs, undolist ) =
    msgs
        |> List.map step
        |> pipe ( UndoList.lengthPast undolist, UndoList.lengthFuture undolist )


update : Msg a -> UndoList a -> UndoList a
update msg undolist =
    case msg of
        Reset ->
            UndoList.reset undolist

        Redo ->
            UndoList.redo undolist

        Undo ->
            UndoList.undo undolist

        Forget ->
            UndoList.forget undolist

        New n ->
            UndoList.new n undolist


step : Msg a -> ( Int, Int ) -> ( Int, Int )
step msg ( pastLen, futureLen ) =
    case msg of
        Reset ->
            ( 0, 0 )

        Redo ->
            if futureLen == 0 then
                ( pastLen, futureLen )
            else
                ( pastLen + 1, futureLen - 1 )

        Undo ->
            if pastLen == 0 then
                ( pastLen, futureLen )
            else
                ( pastLen - 1, futureLen + 1 )

        Forget ->
            ( 0, futureLen )

        New _ ->
            ( pastLen + 1, 0 )


pipe : state -> List (state -> state) -> List state
pipe state msgs =
    case msgs of
        [] ->
            [ state ]

        f :: fs ->
            state :: pipe (f state) fs



-- COMPATIBILITY


for =
    flip Check.for


is =
    flip Check.is


that =
    flip Check.that
