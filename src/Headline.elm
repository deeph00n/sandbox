module Headline exposing (view)
import Html exposing (..)
import Json.Decode as JD

view: JD.Value -> Html msg
view data =
    let
        decode : JD.Value -> Result String String
        decode d =
            JD.decodeValue (JD.succeed String) d

    in
    case (decode data) of
        Ok value ->
            h1 [] [text value]

        Err error ->
            Html

