module GlobalMsg exposing (..)

import Core exposing (Id)
import Json.Decode as Decode

type GlobalMsg
    = ComponentMsg Id Decode.Value