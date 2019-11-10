module SmallHeadline exposing (view)

import Html exposing (..)
import Json.Decode as JD


view: JD.Value -> Html msg
view data =
    h3 [] [ text "smallHeadline" ]
