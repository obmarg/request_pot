module Components.IntroBox (Model, init, Action, update, Context, view) where

import Html exposing (div, p, button, br, h2, text, input)
import Html.Attributes exposing (class, type')
import Html.Events exposing (on, targetChecked, onClick)

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

type alias Context =
  { actions: Signal.Address Action
  , create: Signal.Address () }

onCheck : Signal.Address Action -> Html.Attribute
onCheck address =
  let
    boolToAction = \bool -> if bool then SetPrivate else SetNotPrivate
  in
    on "click" targetChecked (\bool -> Signal.message address (boolToAction bool))

view : Context -> Html.Html
view context =
  div [ class "jumbotron" ]
      [ h2 [] [ (text "Welcome to Request Pot!") ]
      , p [ class "lead" ] [ text "A requestb.in clone written using phoenix & elm."]
      , successButton (onClick context.create ()) "Create a Pot"
      , br [] []
      , input [ type' "checkbox", onCheck context.actions ] []
      , text "Private Pot (only viewable from this browser)"
      ]

successButton : Html.Attribute -> String -> Html.Html
successButton clickHandler btnText =
  button [ class "btn btn-success", clickHandler ] [ text btnText ]
