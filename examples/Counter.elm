import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import UndoList as UL exposing (UndoList, Action(..))

-------------------------------
-- Version with undo support --
-------------------------------

init = 0

type Msg
  = Increment

update msg state =
  case msg of
    Increment ->
        state + 1

view state =
  div
      []
      [ button
            [ onClick (New Increment) ]
            [ text "Increment" ]
      , button
            [ onClick Undo ]
            [ text "Undo" ]
      , div
            []
            [ text (toString state) ]
      ]


main =
  Html.beginnerProgram
    { model = UL.fresh init
    , update = UL.update update
    , view = view
    }



----------------------------------
-- Version without undo support --
----------------------------------

{-}
init = 0

type Msg
  = Increment

update msg state =
  case msg of
    Increment ->
        state + 1

view state =
  div
      []
      [ button
            [ onClick Increment ]
            [ text "Increment" ]
      , div
            []
            [ text (toString state) ]
      ]


main =
  Html.beginnerProgram
    { model = init
    , update = update
    , view = view
    }
-}
