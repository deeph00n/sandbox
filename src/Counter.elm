module Counter exposing (Data, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as JD
import Json.Encode as JE

type alias Data =
    Int

type Msg
    = Increment
    | MsgError

decode : JD.Value -> Msg
decode a =
    case (JD.decodeValue msgDecode a) of
        Ok msg -> msg
        Err _ -> MsgError


msgDecode =
    JD.succeed Increment

encode : Msg -> JD.Value
encode msg =
    case msg of
        Increment -> JE.string "Increment"

        MsgError -> JE.string "MsgError"



update : JD.Value -> Data -> Data
update m data  =
    case decode(m) of
        Increment ->
            data + 1

        MsgError ->
            data


view : Data -> (JD.Value -> msg) -> Html msg
view data toMsg =
    h2 []
        [ text (String.fromInt data)
        , text "  "
        , button [ onClick (toMsg (encode Increment)) ] [ text "Add" ]
        ]
