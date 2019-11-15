module Headline exposing (..)

import Html exposing (..)

type alias Model =
    String


view : Model -> Html msg
view model =
    h1 [] [ text model ]
