module SmallHeadline exposing (view)

import Html exposing (..)
import Json.Decode as JD


view : JD.Value -> Result JD.Error (Html msg)
view data =
    case JD.decodeValue JD.string data of
        Ok value ->
            Ok (h3 [] [ text value ])

        Err error ->
            Err error
