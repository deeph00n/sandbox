module Main exposing (..)

import Browser exposing (..)
import Counter exposing (Model, update, view)
import Dict exposing (Dict)
import Headline
import Html exposing (..)
import Json.Decode as JD
import Teaser


type alias Id =
    Int


type Component
    = Teaser Teaser.Model
    | Headline Headline.Model
    | Counter Counter.Model


type alias Model =
    Dict Id Component


type Msg
    = CmpMsg Id JD.Value


init : Model
init =
    Dict.fromList
        [ ( 1, Headline "I'm a headline" )
        , ( 2
          , Teaser
                { headline = "Hello, world"
                , image = "https://baconmockup.com/450/300"
                , description = "Lorem ipsum"
                }
          )
        , ( 3, Headline "I'm also a headline" )
        , ( 4, Counter 1 )
        , ( 5, Counter 10 )
        , ( 6, Counter 11 )
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        CmpMsg id msgToCmp ->
            let
                updateComponent : Maybe Component -> Maybe Component
                updateComponent maybeCmp =
                    case maybeCmp of
                        Just theCmp ->
                            Just <| case theCmp of
                                Teaser m ->
                                    Teaser m

                                Headline m ->
                                    Headline m

                                Counter m ->
                                     Counter (Counter.update msgToCmp m)

                        Nothing ->
                            Nothing

            in
            Dict.update id updateComponent model


view : Model -> Html Msg
view model =
    div [] <|
        List.map nodeView (Dict.toList model)


nodeView : (Id, Component) -> Html Msg
nodeView (id, component) =
    componentView id component


componentView : Id -> Component -> Html Msg
componentView id component =
    case component of
        Teaser model ->
            Teaser.view model

        Headline model ->
            Headline.view model

        Counter model ->
            Counter.view model (CmpMsg id)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
