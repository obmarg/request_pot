module RequestPot exposing (main)

import Html exposing (text)
import Html.App as Html
import Json.Decode exposing (decodeValue)
import Platform.Sub exposing (map)

import IntroScreen
import PotScreen
import ChannelMessages exposing (..)

-- App

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Model

type ActiveScreen = IntroScreenActive | PotScreenActive

type alias Model =
  { activeScreen: ActiveScreen
  , intro: IntroScreen.Model
  , pot: PotScreen.Model }

init : (Model, Cmd Msg)
init = ( Model IntroScreenActive IntroScreen.init PotScreen.init
       , Cmd.none
       )

-- Update

-- TODO: Do these belong in ChannelMessages.elm?
createPot : Cmd msg
createPot = CreatePot |> encodeOutgoing |> outgoing_message

joinPotChannel : String -> Cmd msg
joinPotChannel pot_name =
  pot_name |> JoinPotChannel |> encodeOutgoing |> outgoing_message

type Msg
  = IntroScreenMsg IntroScreen.Msg
  | ChannelMessage (Result String IncomingChannelMessage)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    IntroScreenMsg IntroScreen.Create ->
      ( { model | intro = IntroScreen.update IntroScreen.Create model.intro }
      , createPot
      )

    IntroScreenMsg msg ->
      ( { model | intro = IntroScreen.update msg model.intro }
      , Cmd.none
      )

    ChannelMessage (Ok channel_message) ->
      case channel_message of
        IncomingRequest pot_name request ->
          -- TODO: use pot_name to verify we care about this?
          ({model | pot = PotScreen.update (PotScreen.IncomingRequest request) model.pot}
          , Cmd.none)

        SetRequests pot_name requests ->
          -- TODO: use pot_name to verify we care about this?
          ({ model | pot = PotScreen.update (PotScreen.SetRequests requests) model.pot}
          , Cmd.none)

        CreatePotResponse (Ok pot_info) ->
          ({ model | activeScreen = PotScreenActive
                   , pot = PotScreen.update (PotScreen.SetInfo pot_info) model.pot}
          , joinPotChannel pot_info.name
          )

        CreatePotResponse (Err error_string) ->
          -- TODO: Display an error on IntroScreen
          (model, Cmd.none)

    ChannelMessage (Err string) ->
      -- TODO: Display an error screen somehow...
      --       Probably with a link to start again...
      (model, Cmd.none)


-- View

view : Model -> Html.Html Msg
view model =
  case model.activeScreen of
    IntroScreenActive ->
      Html.map IntroScreenMsg (IntroScreen.view model.intro)

    PotScreenActive ->
      PotScreen.view model.pot

-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model = map ChannelMessage (incoming_messages (decodeValue incomingDecoder))
