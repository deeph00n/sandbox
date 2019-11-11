module Counter exposing (view)

import Html exposing (..)
import Json.Decode as JD exposing (..)


view : JD.Value -> Result JD.Error (Html msg)
view data =
    case JD.decodeValue JD.int data of
        Ok value ->
            Ok (counterView value)

        Err error ->
            Err error


counterView : Int -> Html msg
counterView value =
    div []
        [ h1 [] [ text <| String.fromInt value ]
        , button [] [ text "Add!" ]
        ]
