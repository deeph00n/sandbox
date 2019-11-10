module Headline exposing (view)
import Html exposing (..)
import Json.Decode as JD

view: JD.Value -> Result JD.Error (Html msg)
view data =
    case (JD.decodeValue JD.string data) of
        Ok value ->
            Ok (h1 [] [text value])

        Err error ->
            Err error

