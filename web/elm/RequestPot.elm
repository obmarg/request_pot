module RequestPot where

import Html exposing (text)
import StartApp.Simple as StartApp

import IntroScreen
import PotScreen

main =
  StartApp.start { model = init, view = view, update = update }

-- Model

type ActiveScreen = IntroScreenActive | PotScreenActive

type alias Model =
  { activeScreen: ActiveScreen
  , intro: IntroScreen.Model
  , pot: PotScreen.Model }

init : Model
init = Model IntroScreenActive IntroScreen.init PotScreen.init

-- Update

type Action
  = Intro IntroScreen.Action
  | Create

update : Action -> Model -> Model
update action model =
  case action of
    Intro act ->
      { model |
          intro = IntroScreen.update act model.intro }

    Create ->
      { model | activeScreen = PotScreenActive }

-- View

view : Signal.Address Action -> Model -> Html.Html
view address model =
  case model.activeScreen of
    IntroScreenActive ->
      let
        context =
          IntroScreen.Context
            (Signal.forwardTo address Intro)
            (Signal.forwardTo address (always Create))
      in
        IntroScreen.view context

    PotScreenActive ->
      PotScreen.view model.pot
