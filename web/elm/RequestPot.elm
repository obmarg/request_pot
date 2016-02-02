module RequestPot where

import Html exposing (text)
import StartApp.Simple as StartApp
import Components.IntroBox

main =
  StartApp.start { model = init, view = view, update = update }

-- Model

type Screen = IntroScreen | PotScreen

type alias Model =
  { intro: Components.IntroBox.Model
  , screen: Screen }

init : Model
init = Model Components.IntroBox.init IntroScreen

-- Update

type Action
  = Intro Components.IntroBox.Action
  | Create

update : Action -> Model -> Model
update action model =
  case action of
    Intro act ->
      { model |
          intro = Components.IntroBox.update act model.intro }

    Create ->
      { model | screen = PotScreen }

-- View

view address model =
  case model.screen of
    IntroScreen ->
      let
        context =
          Components.IntroBox.Context
            (Signal.forwardTo address Intro)
            (Signal.forwardTo address (always Create))
      in
        Components.IntroBox.view context

    PotScreen ->
      if model.intro.private then text "A private request pot" else text "A request pot"
