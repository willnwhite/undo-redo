module TextEditor exposing (..)

import Html exposing (Html)
import Html.App as Html
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (style, value, placeholder)
import UndoList exposing (UndoList)


-- Main


main : Program Never
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }



-- Model


type alias Model =
    UndoList { content : String }


init : Model
init =
    UndoList.fresh { content = "" }



-- Update


type Msg
    = UpdateContent String
    | Undo
    | Redo


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateContent str ->
            UndoList.new { content = str } model

        Undo ->
            UndoList.undo model

        Redo ->
            UndoList.redo model



-- View


view : Model -> Html Msg
view model =
    let
        button msg =
            Html.button
                [ onClick msg
                , style
                    [ "width" => "8em"
                    , "height" => "3em"
                    , "font-size" => "14pt"
                    ]
                ]
                [ Html.text <| toString msg ]

        undoButton =
            button Undo

        redoButton =
            button Redo

        title =
            Html.span
                [ style [ "font-size" => "16pt" ]
                ]
                [ Html.text "Simple Text Area with Undo/Redo support" ]

        headerArea =
            Html.div
                [ style
                    [ "display" => "flex"
                    , "justify-content" => "space-between"
                    , "align-items" => "center"
                    ]
                ]
                [ undoButton
                , title
                , redoButton
                ]

        textArea =
            Html.textarea
                [ onInput UpdateContent
                , value model.present.content
                , placeholder "Enter text here..."
                , style
                    [ "flex" => "1"
                    , "font-size" => "24pt"
                    , "font-family" => "Helvetica Neue, Helvetica, Arial, sans-serif"
                    , "resize" => "none"
                    ]
                ]
                []
    in
        Html.div
            [ style
                [ "position" => "absolute"
                , "margin" => "0"
                , "padding" => "0"
                , "width" => "100vw"
                , "height" => "100vh"
                , "display" => "flex"
                , "flex-direction" => "column"
                ]
            ]
            [ headerArea
            , textArea
            ]



-- Util


(=>) : String -> String -> ( String, String )
(=>) =
    (,)
