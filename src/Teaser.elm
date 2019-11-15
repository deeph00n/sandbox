module Teaser exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias Model =
    { headline : String
    , image : String
    , description : String
    }


view : Model -> Html msg
view model =
    div []
        [ h3 [] [ text model.headline ]
        , img [ src model.image ] []
        , p [] [ text model.description ]
        ]
