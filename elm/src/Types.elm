module Types exposing (..)

import Browser.Navigation as Nav
import Url
import Array exposing (Array, initialize)


type alias Board a = Array (Array a)

type alias BasicModel a =
  { key   : Nav.Key
  , url   : Url.Url
  , state : Board a
  }

type alias Model = BasicModel Int

emptyModel : Url.Url -> Nav.Key -> Model
emptyModel url key =
  { key = key
  , url = url
  , state = initialize 5 (\_ -> initialize 5 (\_ -> 0))
  }

