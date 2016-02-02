module Components.IntroBox (Model, init, Action, update, view) where

import Html exposing (div, p, button, br, h2, text, input)
import Html.Attributes exposing (class, type')
import Html.Events exposing (on, targetChecked)

-- Model

type alias Model = { private : Bool }

init = Model False

-- Update

type Action = SetPrivate | SetNotPrivate | Create

update : Action -> Model -> Model
update action model =
  case action of
    SetPrivate ->
      { model | private = True }

    SetNotPrivate ->
      { model | private = False }

    Create ->
      model

-- View

onCheck : Signal.Address Action -> Html.Attribute
onCheck address =
  let
    boolToAction = \bool -> if bool then SetPrivate else SetNotPrivate
  in
    on "input" targetChecked (\bool -> Signal.message address (boolToAction bool))

view : Signal.Address Action -> Html.Html
view address =
  div [ class "jumbotron" ]
      [ h2 [] [ (text "Welcome to Request Pot!") ]
      , p [ class "lead" ] [ text "A requestb.in clone written using phoenix & elm."]
      , button [ class "btn btn-success" ] [ text "Create a Pot" ]
      , br [] []
      , input [ type' "checkbox", onCheck address ] []
      , text "Private Pot (only viewable from this browser)"
      ]
