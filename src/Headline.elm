module Headline exposing (..)

import Html exposing (..)

type alias Data =
    String


view : Data -> Html msg
view data =
    h1 [] [ text data ]
