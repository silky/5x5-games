module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Types exposing
  ( Model
  , emptyModel
  , Board
  )
import List exposing (map)
import Url exposing (Url)
import Html exposing
  ( Html
  , text
  , div
  , button
  , a
  )
import Html.Events exposing
  ( onClick
  )
import Html.Attributes exposing
  ( id
  , href
  , class
  )
import Array


main : Program () Model Msg
main =
  Browser.application
    { init          = init
    , view          = viewDocument
    , update        = update
    , subscriptions = \_ -> Sub.none
    , onUrlChange   = SomeNavAction << UrlChanged
    , onUrlRequest  = SomeNavAction << LinkClicked
    }

type Msg
  = NoOp
  | SomeNavAction  NavAction
  | ToggleState    Int Int


type NavAction
  = UrlChanged Url
  | LinkClicked Browser.UrlRequest


init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ nav key =
  ( emptyModel nav key
  , Cmd.none
  )

viewDocument : Model -> Browser.Document Msg
viewDocument model =
  { title = "5x5 Games"
  , body  = viewBody model
  }


navUpdate : Model -> NavAction -> (Model, Cmd Msg)
-- TODO: Implement
navUpdate model a = ( model, Cmd.none )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )
    SomeNavAction a -> navUpdate model a
    ToggleState i j ->
      let
          nbhrs = [ (0, 0), (-1, 0), (0, -1), (1, 0), (0, 1) ]
          ss = List.foldl f model.state nbhrs
          f (dx, dy) = toggleCell (i + dx) (j + dy)
          newModel = { model | state = ss }
      in ( newModel, Cmd.none )


toggleCell : Int -> Int -> Board Int -> Board Int
toggleCell i j b =
  let r = Maybe.withDefault (Array.initialize 5 (\_ -> 0)) (Array.get i b)
      c = Array.indexedMap (\k v -> if k == j then abs (v - 1) else v) r
      s = Array.set i c b
  in  s


viewBody : Model -> List (Html Msg)
viewBody model =
  let
      nbsp = String.fromChar '\u{00A0}'
      mkRow i cells = div [] <| Array.toList <| Array.indexedMap (mkCell i) cells
      mkCell i j cell =
        let c = if cell == 0 then "" else "active"
        in
        button
          [ onClick <| ToggleState i j
          , class c
          ]
          [ text nbsp ]
  in
  [ div [ class "board" ]
      <| Array.toList
      <| Array.indexedMap mkRow model.state
  ]
