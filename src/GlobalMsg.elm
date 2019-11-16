module GlobalMsg exposing (..)

import Core exposing (Id)
import Counter exposing (..)

import Html exposing (Html)
import Json.Decode as Decode

type ComponentMsg
    = Counter Counter.CounterMsg


toCounterMsg : ComponentMsg -> Maybe CounterMsg
toCounterMsg componentMsg =
    case componentMsg of
        Counter ccm ->
            Just ccm



type GlobalMsg
    = SystemMsg Id ComponentMsg



