module RequestPot where

import Effects exposing (Effects, Never)
import Html exposing (text)
import StartApp

import IntroScreen
import PotScreen

-- App

app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = [ incomingRequests ]
    }

main = app.html

-- Model

type ActiveScreen = IntroScreenActive | PotScreenActive

type alias Model =
  { activeScreen: ActiveScreen
  , intro: IntroScreen.Model
  , pot: PotScreen.Model }

init : (Model, Effects Action)
init = ( Model IntroScreenActive IntroScreen.init PotScreen.init
       , Effects.none
       )

-- Update

type Action
  = IntroScreenAction IntroScreen.Action
  | Create
  | SetRequests (List String)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    IntroScreenAction act ->
      ( { model |
          intro = IntroScreen.update act model.intro }
      , Effects.none
      )

    Create ->
      ( { model | activeScreen = PotScreenActive }
      , Effects.none
      )

    SetRequests requests ->
      let
        pot = model.pot
        updatedPot = { pot | requests = requests }
      in
        ( { model | pot = updatedPot }
        , Effects.none )

-- View

view : Signal.Address Action -> Model -> Html.Html
view address model =
  case model.activeScreen of
    IntroScreenActive ->
      let
        context =
          IntroScreen.Context
            (Signal.forwardTo address IntroScreenAction)
            (Signal.forwardTo address (always Create))
      in
        IntroScreen.view context

    PotScreenActive ->
      PotScreen.view model.pot

-- Signals

port requests : Signal (List String)

incomingRequests : Signal Action
incomingRequests =
  Signal.map SetRequests requests
