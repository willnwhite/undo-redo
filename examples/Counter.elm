module Counter exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import UndoList exposing (UndoList)
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import Html.App as Html
import UndoList exposing (UndoList)


main : Program Never
main =
    Html.beginnerProgram
        { model = UndoList.fresh 0
        , view = view
        , update = update
        }


type alias Model =
    UndoList Int


type Msg
    = Increment
    | Undo
    | Redo


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            UndoList.new (model.present + 1) model

        Undo ->
            UndoList.undo model

        Redo ->
            UndoList.redo model


view : Model -> Html Msg
view model =
    div
        []
        [ button
            [ onClick Increment ]
            [ text "Increment" ]
        , button
            [ onClick Undo ]
            [ text "Undo" ]
        , button
            [ onClick Redo ]
            [ text "Redo" ]
        , div
            []
            [ text (toString model) ]
        ]
