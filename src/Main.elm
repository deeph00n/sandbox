module Main exposing (main)

import ActorName exposing (ActorName)
import Address exposing (Address(..))
import Bootstrap exposing (AppModel, bootstrap)
import Html exposing (Html, a, div, h1, node, p, text)
import Json.Encode as Encode
import Msg exposing (AppMsg(..), Msg)
import System.Browser exposing (element)
import System.Log exposing (LogMessage, toString)
import System.Message exposing (..)
import System.Platform exposing (Program)


main : Program () Address ActorName AppModel AppMsg
main =
    element
        { apply = bootstrap.apply
        , factory = bootstrap.factory
        , init = init
        , view = view
        , onLogMessage = onLogMessage
        }


init : () -> List Msg
init _ =
    [ spawnWithFlags (Encode.int 0) ActorName.Counter populateView
    , spawnWithFlags (Encode.int 10) ActorName.Counter populateView
    ]


view : List (Html Msg) -> Html Msg
view contents =
    div []
        [ h1 [] [ text "Hello, actors!" ]
        , div [ ] contents
        ]


onLogMessage :
    LogMessage Address ActorName AppMsg
    -> SystemMessage Address ActorName AppMsg
onLogMessage _ =
    noOperation
