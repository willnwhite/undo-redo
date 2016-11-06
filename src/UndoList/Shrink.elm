module UndoList.Shrink exposing (undolist, msg)

{-| Shrink UndoList Submodule.

Provides shrinking strategies for timelines and messages.

# Shrinkers
@docs undolist, msg

-}

import Shrink exposing (Shrinker)
import UndoList exposing (UndoList, Msg(..))
import Lazy.List as Lazy exposing (LazyList)


{-| Shrink an undo-list of states given a shrinker of states.
-}
undolist : Shrinker state -> Shrinker (UndoList state)
undolist shrinker { past, present, future } =
    let
        --pasts : LazyList (List state)
        pasts =
            Shrink.list shrinker past

        --futures : LazyList (List state)
        futures =
            Shrink.list shrinker future

        --presents : LazyList state
        presents =
            shrinker present

        append f arg other =
            Lazy.append other (Lazy.map f arg)

        append2 f a1 a2 other =
            Lazy.append other (Lazy.map2 f a1 a2)
    in
        Lazy.map (\past -> UndoList past present future) pasts
            |> append (\present -> UndoList past present future) presents
            |> append (\future -> UndoList past present future) futures
            |> append2 (\past present -> UndoList past present future) pasts presents
            |> append2 (\past future -> UndoList past present future) pasts futures
            |> append2 (\present future -> UndoList past present future) presents futures
            |> Lazy.append (Lazy.map3 UndoList pasts presents futures)


{-| Shrink an undo-list msg given an msg shrinker.
Considers `Reset` to be most minimal.
-}
msg : Shrinker msg -> Shrinker (Msg msg)
msg shrinker msg =
    case msg of
        Reset ->
            Lazy.empty

        Forget ->
            Lazy.singleton Reset

        Undo ->
            Lazy.fromList [ Forget, Reset ]

        Redo ->
            Lazy.fromList [ Undo, Forget, Reset ]

        New newMsg ->
            let
                head =
                    Lazy.fromList <| [ Undo, Redo, Forget, Reset ]
            in
                Lazy.append head (Lazy.map New (shrinker newMsg))
