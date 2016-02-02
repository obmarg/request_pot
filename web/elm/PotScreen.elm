module PotScreen (Model, init, view) where

import List exposing (isEmpty)
import Html exposing (text, p, section, h4, input, div)
import Html.Attributes exposing (class, style, type', value, readonly)

-- Model

type alias Request = String
type alias Requests = List Request

type alias Model =
  { requests: Requests }


init : Model
init = Model []

-- Update

-- TODO: So, want a centered text box w/ the pot URL in it.
-- Then optionally the requests that have been made.
view : Model -> Html.Html
view model =
  let
    requestsView = if isEmpty model.requests
                   then viewNoRequests
                   else viewRequests model.requests
  in
    div [ class "text-center" ] [ viewPotUrl, requestsView ]

viewPotUrl : Html.Html
viewPotUrl = section []
            [ h4 [] [ text "Pot URL" ]
            , input [ type' "text"
                    , value "http://localhost:4000/whatever"
                    , readonly True
                    , class "input-lg"] []
            ]

viewRequests : Requests -> Html.Html
viewRequests requests =
  text "Some Requests1"

viewNoRequests : Html.Html
viewNoRequests =
  text (  "There are no requests right now.  "
       ++ "Make some requests to the URL above and this page will update.")
