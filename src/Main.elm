module Main exposing (..)

import Browser exposing (..)
import Core exposing (Id)
import Counter exposing (Model, update, view)
import Dict exposing (Dict)
import GlobalMsg exposing (GlobalMsg(..), toCounterMsg, toGlobalHtmlMsg)
import Headline
import Html exposing (..)
import Teaser


type Component
    = Teaser Teaser.Model
    | Headline Headline.Model
    | Counter Counter.Model


type alias Model =
    Dict Id Component


init : Model
init =
    Dict.fromList
        [ ( 1, Headline "I'm a headline" )
        , ( 2
          , Teaser
                { headline = "Hello, world"
                , image = "https://baconmockup.com/250/150"
                , description = "Lorem ipsum"
                }
          )
        , ( 3, Headline "I'm also a headline" )
        , ( 4, Counter 1 )
        , ( 5, Counter 10 )
        , ( 6, Counter 11 )
        ]


update : GlobalMsg -> Model -> Model
update globalMsg model =
    case globalMsg of
        SystemMsg id msgToCmp ->
            let
                updateComponent : Maybe Component -> Maybe Component
                updateComponent maybeCmp =
                    case maybeCmp of
                        Just theCmp ->
                            Just <|
                                case theCmp of
                                    Counter counterModel ->
                                            case (toCounterMsg msgToCmp) of
                                                Just counterMsg ->
                                                    Counter (Counter.update counterMsg counterModel)
                                                Nothing ->
                                                    theCmp
                                    _ ->
                                        theCmp

                        Nothing ->
                            Nothing
            in
            Dict.update id updateComponent model


view : Model -> Html GlobalMsg
view model =
    div [] <|
        List.map componentView (Dict.toList model)





componentView : ( Id, Component ) -> Html GlobalMsg
componentView (id, component) =
    case component of
        Teaser model ->
            Teaser.view model

        Headline model ->
            Headline.view model

        Counter model ->
            Counter.view model (SystemMsg id)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
