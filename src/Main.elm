module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Html exposing (..)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Url exposing (Url)



-- Model


type alias PageData =
    { title : String
    , headline : String
    , description : String
    }


type alias Page =
    { layout : String
    , data : PageData
    }


type Resource data
    = Loading
    | Result data
    | Error


type alias Model =
    { page : Resource Page }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { page = Loading }
    , Http.get { url = "/index.json", expect = Http.expectJson GotPage pageDecoder }
    )



-- Update


type Msg
    = GotPage (Result Http.Error Page)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPage result ->
            let
                newPage =
                    case result of
                        Ok value ->
                            Result value

                        Err error ->
                            Error
            in
            ( { model | page = newPage }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Document Msg
view model =
    case model.page of
        Loading ->
            { title = "Loading..."
            , body = [ text "Loading..." ]
            }

        Error ->
            { title = "Error!"
            , body = [ text "Error loading the data" ]
            }

        Result page ->
            { title = page.data.title
            , body =
                [ h1 [] [ text page.data.headline ]
                , p [] [ text page.data.description ]
                , div [] [ text page.layout ]
                ]
            }



-- SUBSCRIPTIONS


subscriptions : model -> Sub Msg
subscriptions _ =
    Sub.none



-- URL changes


onUrlRequest : UrlRequest -> Msg
onUrlRequest request =
    NoOp


onUrlChange : Url -> Msg
onUrlChange url =
    NoOp



-- Decoders


pageDecoder : JD.Decoder Page
pageDecoder =
    JD.succeed Page
        |> JDP.required "Layout" JD.string
        |> JDP.required "Data" pageDataDecoder


pageDataDecoder : JD.Decoder PageData
pageDataDecoder =
    JD.succeed PageData
        |> JDP.required "Title" JD.string
        |> JDP.required "Headline" JD.string
        |> JDP.required "Description" JD.string



-- Main


main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }
