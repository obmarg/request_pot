module RequestPot where

import Html exposing (div, button, text)
import StartApp.Simple as StartApp
import Components.IntroBox

main =
  StartApp.start { model = init, view = view, update = update }

type alias Model =
  { intro: Components.IntroBox.Model }

init : Model
init = Model Components.IntroBox.init

view : Signal.Address Action -> Model -> Html.Html
view address model = Components.IntroBox.view (Signal.forwardTo address Intro)


type Action = Intro Components.IntroBox.Action


update : Action -> Model -> Model
update action model =
  case action of
    Intro act ->
      { model |
          intro = Components.IntroBox.update act model.intro }
