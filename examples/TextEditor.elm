module Main exposing (..)

import Html exposing (Html)
import Html.App as Html
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (style, value, placeholder)
import UndoList as UL exposing (Msg(..), UndoList)


-- View


view : Model -> Html (UL.Msg Msg)
view model =
    let
        button value =
            Html.button
                [ onClick value
                , style
                    [ "width" => "8em"
                    , "height" => "3em"
                    , "font-size" => "14pt"
                    ]
                ]
                [ Html.text <| toString value ]

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
                [ onInput (New << UpdateContent)
                , value model.content
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



-- Model


type alias Model =
    { content : String }



-- The initial state of the entire application


init : Model
init =
    { content = "" }



-- Update


type Msg
    = UpdateContent String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateContent str ->
            { content = str }



-- Main


main : Program Never
main =
    Html.beginnerProgram
        { model = UL.fresh init
        , update = UL.update update
        , view = UL.view view
        }



-- Util


(=>) : String -> String -> ( String, String )
(=>) =
    (,)
