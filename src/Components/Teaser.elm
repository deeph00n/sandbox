module Teaser exposing (view)

import Html exposing (..)
import Html.Attributes exposing (src, style)
import Json.Decode as JD
import Json.Decode.Pipeline as JDP


view : JD.Value -> Result JD.Error (Html msg)
view data =
    case JD.decodeValue teaserDecoder data of
        Ok teaser ->
            Ok (teaserView teaser)

        Err error ->
            Err error


teaserView : Teaser -> Html msg
teaserView teaser =
    div [ style "width" "400px" ]
        [ h2 [] [ text teaser.headline ]
        , img [ src teaser.imageSrc ] []
        , p [] [ text teaser.text ]
        ]


type alias Teaser =
    { headline : String
    , imageSrc : String
    , text : String
    }


teaserDecoder : JD.Decoder Teaser
teaserDecoder =
    JD.succeed Teaser
        |> JDP.required "Headline" JD.string
        |> JDP.required "Image" JD.string
        |> JDP.required "Text" JD.string
