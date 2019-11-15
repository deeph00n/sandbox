module Bootstrap exposing (AppModel(..), bootstrap)

import ActorName exposing (ActorName(..))
import Counter.Actor as Counter exposing (Model, actor)
import System.Actor exposing (toSystemActor)



type AppModel
    = CounterModel Counter.Model


bootstrap =
    { apply = apply
    , factory = factory
    }


actors =
    { counter = Counter.actor CounterModel
    }


factory actorName =
    case actorName of
        Counter ->
            actors.counter.init


apply model =
    case model of
        CounterModel m ->
            toSystemActor actors.counter m