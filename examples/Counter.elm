import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import UndoList as UL exposing (UndoList, Action(..))

-------------------------------
-- Version with undo support --
-------------------------------

init = 0

update _ state =
  state + 1

view state =
  div
      []
      [ button
            [ onClick (New ()) ]
            [ text "Increment" ]
      , button
            [ onClick Undo ]
            [ text "Undo" ]
      , button
            [ onClick Redo ]
            [ text "Redo" ]
      , div
            []
            [ text (toString state) ]
      ]


main =
  Html.beginnerProgram
    { model = UL.fresh init
    , update = UL.update update
    , view = UL.view view
    }



----------------------------------
-- Version without undo support --
----------------------------------

{--
init = 0

update _ state =
  state + 1

view state =
  div
      []
      [ button
            [ onClick () ]
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
--}
