module Main exposing (..)

import Browser exposing (..)
import Headline
import Html exposing (..)
import Json.Decode as JD
import Teaser
import Counter exposing (update, Data, view)

type alias Id = Int

type Component
    = Teaser Teaser.Data
    | Headline Headline.Data
    | Counter Counter.Data

type alias Node =
    { id : Id
    , component : Component
    }


type alias Model =
    List Node

type Msg
    = CmpMsg Id JD.Value


init : Model
init =
    [ { id = 1, component = Headline "I'm a headline" }
    , { id = 2
      , component =
            Teaser
                { headline = "Hello, world"
                , image = "https://baconmockup.com/450/300"
                , description = "Lorem ipsum"
                }
      }
    , { id = 3, component = Headline "I'm also a headline" }
    , { id = 4, component = Counter 1 }
    , { id = 5, component = Counter 10 }
    , { id = 6, component = Counter 11 }
    ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        CmpMsg id m ->
            let
                inc : Node -> Node
                inc node =
                    if (node.id == id) then
                        case node.component of
                            Counter data ->
                                {id = id, component = Counter <| Counter.update m data }
                            _ -> node
                    else
                        node

            in
            List.map inc model


view : Model -> Html Msg
view model =
    div [] <|
        List.map nodeView model

nodeView : Node -> Html Msg
nodeView node =
    componentView node.id node.component

componentView : Id -> Component -> Html Msg
componentView id component =
    case component of
        Teaser data ->
            Teaser.view data

        Headline data ->
            Headline.view data

        Counter data ->
            Counter.view data (CmpMsg id)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
