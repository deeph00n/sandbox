module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Counter
import Headline
import Html exposing (..)
import Html.Attributes exposing (href)
import Http exposing (Error(..))
import Json.Decode as JD exposing (..)
import Json.Decode.Pipeline as JDP
import SmallHeadline
import Teaser
import Url exposing (Url)



-- Model


type Layout
    = Test
    | About


type alias Component =
    { view : Html Msg }


type alias Page =
    { layout : Layout
    , title : String
    , components : List Component
    }


type Resource data
    = Loading
    | Result data
    | Error Http.Error


type alias Model =
    { key : Nav.Key
    , page : Resource Page
    }


convertUrl : Url -> String
convertUrl url =
    if url.path == "/" then
        "/index.json"

    else
        url.path ++ ".json"


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , page = Loading
      }
    , Http.get { url = convertUrl url, expect = Http.expectJson GotPage pageDecoder }
    )



-- Update


type Msg
    = GotPage (Result Http.Error Page)
    | GetPage Url
    | LinkClicked Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetPage url ->
            ( { model | page = Loading }
            , Http.get
                { url = convertUrl url
                , expect = Http.expectJson GotPage pageDecoder
                }
            )

        GotPage result ->
            let
                newPage =
                    case result of
                        Ok page ->
                            Result page

                        Err error ->
                            Error error
            in
            ( { model | page = newPage }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )



-- View


view : Model -> Document Msg
view model =
    case model.page of
        Loading ->
            { title = "Loading..."
            , body = [ text "Loading..." ]
            }

        Error error ->
            let
                parseError e =
                    case e of
                        BadUrl message ->
                            "BadUrl: " ++ message

                        Timeout ->
                            "Timeout"

                        NetworkError ->
                            "Network error"

                        BadStatus statusCode ->
                            "Bad status " ++ String.fromInt statusCode

                        BadBody message ->
                            "Bad response body: " ++ message
            in
            { title = "Error!"
            , body = [ text (parseError error) ]
            }

        Result page ->
            { title = page.title
            , body =
                [ navView
                , div [] (pageView page)
                ]
            }


navView : Html Msg
navView =
    div []
        [ a [ href "/" ] [ text "Home" ]
        , text " | "
        , a [ href "/about" ] [ text "About" ]
        ]


pageView : Page -> List (Html Msg)
pageView page =
    case page.layout of
        Test ->
            [ h1 [] [ text "This is a test page!" ]
            , div [] (List.map componentView page.components)
            ]

        About ->
            [ h1 [] [ text "This is an about page" ]
            , div [] (List.map componentView page.components)
            ]


componentView : Component -> Html Msg
componentView component =
    div [] [ component.view ]



-- SUBSCRIPTIONS


subscriptions : model -> Sub Msg
subscriptions _ =
    Sub.none



-- URL changes


onUrlRequest : UrlRequest -> Msg
onUrlRequest request =
    LinkClicked request


onUrlChange : Url -> Msg
onUrlChange url =
    GetPage url



-- Decoders


pageDecoder : JD.Decoder Page
pageDecoder =
    JD.succeed Page
        |> JDP.required "Layout" layoutDecoder
        |> JDP.required "Title" JD.string
        |> JDP.required "Components" (JD.list componentDecoder)


componentDecoder : JD.Decoder Component
componentDecoder =
    let
        parseResult : Result JD.Error (Html Msg) -> JD.Decoder Component
        parseResult result =
            case result of
                Ok value ->
                    JD.succeed (Component value)

                Err error ->
                    JD.fail (JD.errorToString error)

        toDecoder : String -> JD.Value -> JD.Decoder Component
        toDecoder type_ data =
            case type_ of
                "Headline" ->
                    Headline.view data |> parseResult

                "Teaser" ->
                    Teaser.view data |> parseResult

                "SmallHeadline" ->
                    SmallHeadline.view data |> parseResult

                "Counter" ->
                    Counter.view data |> parseResult

                somethingElse ->
                    JD.fail <| "Unknown component type: \"" ++ somethingElse ++ "\""
    in
    JD.succeed toDecoder
        |> JDP.required "Type" JD.string
        |> JDP.required "Data" JD.value
        |> JDP.resolve


layoutDecoder : JD.Decoder Layout
layoutDecoder =
    JD.string
        |> JD.andThen
            (\str ->
                case str of
                    "Test" ->
                        JD.succeed Test

                    "About" ->
                        JD.succeed About

                    somethingElse ->
                        JD.fail <| "Unknown layout: " ++ somethingElse
            )



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
