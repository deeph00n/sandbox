module Counter exposing (Model, update, view, CounterMsg(..))

import GlobalMsg exposing (ComponentMsg, GlobalMsg)
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as JD
import Json.Encode as JE

type alias Model =
    Int

type CounterMsg
    = Increment
    | MsgError


update : CounterMsg -> Model -> Model
update msg model  =
    case msg of
        Increment ->
            model + 1

        MsgError ->
            model


view : Model -> (ComponentMsg -> GlobalMsg) -> Html GlobalMsg
view model toMsg =
    h2 []
        [ text (String.fromInt model)
        , text "  "
        , button [ onClick (toMsg Increment) ] [ text "Add" ]
        ]
