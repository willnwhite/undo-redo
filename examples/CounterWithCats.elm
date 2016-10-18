module CounterWithCats exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import UndoList exposing (UndoList)
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import Html.App as Html
import UndoList exposing (UndoList)
import Http
import Task
import Json.Decode as Json


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    UndoList
        { counter : Int
        , gifUrl : Maybe String
        }


type Msg
    = Increment
    | Undo
    | Redo
    | FetchSucceed String
    | FetchFail Http.Error


init : ( Model, Cmd msg )
init =
    ( UndoList.fresh { counter = 0, gifUrl = Nothing }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ present } as model) =
    case msg of
        Increment ->
            ( UndoList.new
                { present | counter = present.counter + 1 }
                model
            , getRandomGif "cats"
            )

        Undo ->
            ( UndoList.undo model, Cmd.none )

        Redo ->
            ( UndoList.redo model, Cmd.none )

        FetchSucceed newUrl ->
            ( UndoList.mapPresent
                (\present -> { present | gifUrl = Just newUrl })
                model
            , Cmd.none
            )

        FetchFail _ ->
            ( model, Cmd.none )


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
            [ text (toString model.present.counter) ]
        , div
            []
            (case model.present.gifUrl of
                Just gifUrl ->
                    [ img [ src gifUrl ] [] ]

                Nothing ->
                    [ text "Increment to display a GIF image" ]
            )
        ]



-- Taken from https://guide.elm-lang.org/architecture/effects/http.html


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string
