module IntroScreen exposing (Model, init, Msg, update, view)

import Html exposing (div, p, button, br, h2, text, input, Html)
import Html.Attributes exposing (class, type', checked)
import Html.Events exposing (on, onClick, onCheck)

-- Model

type alias Model = { private : Bool }

init = Model False

-- Update

type Msg = Private Bool | Create

update : Msg -> Model -> Model
update msg model =
  case msg of
    Private bool ->
      { model | private = bool }

    Create ->
      model

-- View

view : Model -> Html Msg
view model =
  div [ class "jumbotron" ]
      [ h2 [] [ (text "Welcome to Request Pot!") ]
      , p [ class "lead" ] [ text "A requestb.in clone written using phoenix & elm."]
      , successButton (onClick Create) "Create a Pot"
      , br [] []
      , input [ type' "checkbox", checked model.private, onCheck Private ] []
      , text "Private Pot (only viewable from this browser)"
      ]

successButton : Html.Attribute Msg -> String -> Html Msg
successButton clickHandler btnText =
  button [ class "btn btn-success", clickHandler ] [ text btnText ]
