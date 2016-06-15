module PotScreen exposing (Model, init, view, Msg (..), update)

import List exposing (isEmpty, map)
import Html exposing (Html, text, p, section, h4, input, div, table, thead, tbody, tr, td, th, span)
import Html.Attributes exposing (class, style, type', value, readonly)

import ChannelMessages exposing (Request, PotInfo)

-- Model

type alias Requests = List Request

type alias Model =
  { requests: Requests, potInfo: Maybe PotInfo }


init : Model
init = Model [] Nothing

-- Update

type Msg
  = SetRequests Requests
  | IncomingRequest Request
  | SetInfo PotInfo

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetRequests requests ->
      {model | requests = requests}
    IncomingRequest request ->
      {model | requests = request :: model.requests}
    SetInfo info ->
      {model | potInfo = Just info}


-- View

view : Model -> Html msg
view model =
  let
    requestsView = if isEmpty model.requests
                   then viewNoRequests
                   else viewRequests model.requests
    urlView = viewPotUrl model.potInfo
  in
    div [ class "text-center" ] [ urlView, requestsView ]

viewPotUrl : Maybe PotInfo -> Html msg
viewPotUrl info =
  let
    url = case info of
      Just potInfo ->
        potInfo.url
      Nothing -> ""
  in
    section []
      [ h4 [] [ text "Pot URL" ]
      , input [ type' "text"
              , value url
              , readonly True
              , class "input-lg"] []
      ]


-- TODO: This needs to render some actual rows for the requests.
-- can probably not bother with the actual request details for now.
-- can finalize that later.
viewRequests : Requests -> Html msg
viewRequests requests =
  table [ class "table table-striped text-left" ] ([
           thead [] [ tr []
                        [ th [] [text "Method"]
                        , th [] [text "Path"]
                        , th [] [text "Content-Type"]
                        , th [] [text "IP"]
                        , th [] [text "Time"]
                        ]
                    ]
          ] ++ [ tbody [] (map viewRequest requests) ])

viewRequest : Request -> Html msg
viewRequest request =
  let
    contentType =
      case request.content_type of
        Just contentType -> contentType
        Nothing -> ""
  in
    tr [] [ td [] [methodLabel request.method]
          , td [] [text request.path]
          , td [] [text contentType]
          , td [] [text request.remote_addr]
          , td [] [text (toString request.time)]
          ]

methodLabel : String -> Html msg
methodLabel method =
  let
    labelType = case method of
                  "GET" -> "label-success"
                  "DELETE" -> "label-danger"
                  _ -> "label-primary"
  in
    span [ class ("label " ++ labelType) ] [text method]


viewNoRequests : Html msg
viewNoRequests =
  text (  "There are no requests right now.  "
       ++ "Make some requests to the URL above and this page will update.")
