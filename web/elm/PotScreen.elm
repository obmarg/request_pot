module PotScreen exposing (Model, init, view)

import List exposing (isEmpty, map)
import Html exposing (Html, text, p, section, h4, input, div)
import Html.Attributes exposing (class, style, type', value, readonly)

-- Model

type alias Request = String
type alias Requests = List Request

type alias Model =
  { requests: Requests }


init : Model
init = Model []

-- Update

-- View

view : Model -> Html msg
view model =
  let
    requestsView = if isEmpty model.requests
                   then viewNoRequests
                   else viewRequests model.requests
  in
    div [ class "text-center" ] [ viewPotUrl, requestsView ]

viewPotUrl : Html msg
viewPotUrl = section []
            [ h4 [] [ text "Pot URL" ]
            , input [ type' "text"
                    , value "http://localhost:4000/whatever"
                    , readonly True
                    , class "input-lg"] []
            ]

-- TODO: This needs to render some actual rows for the requests.
-- can probably not bother with the actual request details for now.
-- can finalize that later.
viewRequests : Requests -> Html msg
viewRequests requests =
  div [] (map viewRequest requests)

viewRequest : Request -> Html msg
viewRequest request =
  p [] [ text ("A request! " ++ request) ]

viewNoRequests : Html msg
viewNoRequests =
  text (  "There are no requests right now.  "
       ++ "Make some requests to the URL above and this page will update.")
