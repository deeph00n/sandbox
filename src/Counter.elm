module Counter exposing (Model, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as JD
import Json.Encode as JE

type alias Model =
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



update : JD.Value -> Model -> Model
update m model  =
    case decode(m) of
        Increment ->
            model + 1

        MsgError ->
            model


view : Model -> (JD.Value -> msg) -> Html msg
view model toMsg =
    h2 []
        [ text (String.fromInt model)
        , text "  "
        , button [ onClick (toMsg (encode Increment)) ] [ text "Add" ]
        ]
