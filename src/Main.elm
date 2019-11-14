module Main exposing (..)

import Html exposing (..)
import System.Platform exposing (Program)
import System.Message exposing (SystemMessage)
import System.Browser exposing (element)

type ActorName
    = None



{--
type ActorName
    = Counter
    | Counters
    | Snackbar
--}


type Address
    = None



{--
type Address
    = AllCounters
    | Snackbar
--}


type AppModel
    = None



{--
type AppModel
    = CountersModel Counters.Model
    | CounterModel Counter.Model
    | SnackbarModel Snackbar.Model
--}

type alias Msg =
    SystemMessage Address ActorName AppMsg

type AppMsg
    = Nop

{--
type AppMsg
    = Counters Counters.MsgIn
    | Counter Counter.MsgIn
    | Snackbar Snackbar.MsgIn
    | LogMsg (LogMessage Address ActorName AppMsg)
--}

init : () -> List Msg
init _ =
    []

view : List (Html Msg) -> Html Msg
view contents =
    div []
        [ h1 [] [ text "Hello, actors!" ]
        , div [] contents
        ]

main : Program () Address ActorName AppModel AppMsg
main =
    element
        { apply = bootstrap.apply
        , factory = bootstrap.factory
        , init = init
        , view = view
        , onLogMessage = onLogMessage
        }
