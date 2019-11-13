module Teaser exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias Data =
    { headline : String
    , image : String
    , description : String
    }


view : Data -> Html msg
view data =
    div []
        [ h3 [] [ text data.headline ]
        , img [ src data.image ] []
        , p [] [ text data.description ]
        ]
