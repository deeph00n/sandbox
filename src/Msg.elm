module Msg exposing (AppMsg(..), Msg)

import ActorName exposing (ActorName)
import Address exposing (Address)
import Counter.Component as Counter
import System.Log exposing (LogMessage)
import System.Message exposing (SystemMessage)


type alias Msg =
    SystemMessage Address ActorName AppMsg


type AppMsg
    = Counter Counter.MsgIn
    | LogMsg (LogMessage Address ActorName AppMsg)