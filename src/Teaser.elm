module Teaser exposing (view)
import Html exposing (..)
import Json.Decode as JD

view: JD.Value -> Html msg
view data =
    p [] [ text "teaser" ]