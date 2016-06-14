port module RequestPot exposing (main)

import Html exposing (text)
import Html.App as Html

import IntroScreen
import PotScreen

-- App

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Model

type ActiveScreen = IntroScreenActive | PotScreenActive

type alias Model =
  { activeScreen: ActiveScreen
  , intro: IntroScreen.Model
  , pot: PotScreen.Model }

init : (Model, Cmd Msg)
init = ( Model IntroScreenActive IntroScreen.init PotScreen.init
       , Cmd.none
       )

-- Update

type Msg
  = IntroScreenAction IntroScreen.Msg
  | Create
  | SetRequests (List String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    IntroScreenAction act ->
      ( { model |
          intro = IntroScreen.update act model.intro }
      , Cmd.none
      )

    Create ->
      ( { model | activeScreen = PotScreenActive }
      , Cmd.none
      )

    SetRequests requests ->
      let
        pot = model.pot
        updatedPot = { pot | requests = requests }
      in
        ( { model | pot = updatedPot }
        , Cmd.none )

-- View

view : Model -> Html.Html Msg
view model =
  case model.activeScreen of
    IntroScreenActive ->
      Html.map IntroScreenAction (IntroScreen.view model.intro)

    PotScreenActive ->
      PotScreen.view model.pot

-- Subscriptions

port requests : (List String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model = requests SetRequests
