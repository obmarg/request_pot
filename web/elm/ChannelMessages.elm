port module ChannelMessages exposing (..)

import Dict exposing (Dict)
import Json.Encode
import Json.Decode exposing (Decoder, string, dict, int, null, map, (:=), andThen, oneOf, object2, object1, object4, list, bool, float, fail)

type alias Request =
  { method: String
  , content_type: Maybe String
  , headers: Dict String String
  , path: String
  , query_string: Dict String String
  , id: String
  , form_data: Dict String String
  , body: String
  , remote_addr: String
  , time: Float
  }

type alias PotInfo =
  { name: String
  , private: Bool
  , time_created: Int
  , request_count: Int
  }

type IncomingChannelMessage
  = IncomingRequest String Request
  | SetRequests String (List Request)
  | CreatePotResponse (Result String PotInfo)

type OutgoingChannelMessage
  = CreatePot
  | JoinPotChannel String

-- Decoder for an incoming Json.Value
incomingDecoder : Decoder IncomingChannelMessage
incomingDecoder =
  ("tag" := string) `andThen` incomingDecodeTag

-- Decodes an incoming Json.Value once we've extracted the tag.
incomingDecodeTag : String -> Decoder IncomingChannelMessage
incomingDecodeTag tag =
  case tag of
    "incoming_request" ->
      object2 IncomingRequest ("pot_name" := string) ("request" := requestDecoder)
    "set_requests" ->
      object2 SetRequests ("pot_name" := string) ("requests" := list requestDecoder)
    "create_pot_response" ->
      object1 CreatePotResponse ("result" := oneOf [ map Ok ("pot" := potInfoDecoder)
                                                   , map Err string])
    _ ->
      fail (tag ++ "is not a recognised tag for incoming requests")

andMap : Decoder (a -> b) -> Decoder a -> Decoder b
andMap = object2 (<|)

-- This one is a bit wierd.
-- We simulate object10 with a bunch of maps & andMaps
requestDecoder : Decoder Request
requestDecoder =
  Request
  `map` ("method" := string)
  `andMap` ("content_type" := (oneOf [ null Nothing
                              , map Just string]))
  `andMap` ("headers" := dict string)
  `andMap` ("path" := string)
  `andMap` ("query_string" := dict string)
  `andMap` ("id" := string)
  `andMap` ("form_data" := dict string)
  `andMap` ("body" := string)
  `andMap` ("remote_addr" := string)
  `andMap` ("time" := float)

potInfoDecoder : Decoder PotInfo
potInfoDecoder =
  object4
    PotInfo
    ("name" := string)
    ("private" := bool)
    ("time_created" := int)
    ("request_count" := int)

encodeOutgoing : OutgoingChannelMessage -> Json.Encode.Value
encodeOutgoing msg =
  case msg of
    CreatePot ->
      Json.Encode.object [("tag", Json.Encode.string "create_pot")]
    JoinPotChannel pot_name ->
      Json.Encode.object [ ("tag", Json.Encode.string "join_pot_channel")
                         , ("pot_name", Json.Encode.string pot_name) ]

port incoming_messages : (Json.Decode.Value -> msg) -> Sub msg
port outgoing_message : Json.Decode.Value -> Cmd msg
