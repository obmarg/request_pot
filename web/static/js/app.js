// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";

// Now that you are connected, you can join channels with a topic:
let lobbyChannel = socket.channel("pot:lobby", {});
lobbyChannel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp); })
    .receive("error", resp => { console.log("Unable to join", resp); });


var elmDiv = document.getElementById('elm-main')
  , initialState = { requests: [] }
  , elm = require('../../elm/RequestPot')
  , elmApp = elm.RequestPot.embed(elmDiv)
  , potChannel = null;

elmApp.ports.outgoing_message.subscribe(function (value){
    switch(value.tag) {
    case "create_pot":
        lobbyChannel.push("create_pot", {}, 10000)
            .receive(
                "ok",
                (msg) => elmApp.ports.incoming_messages.send({
                    "tag": "create_pot_response",
                    "result": msg
                })
            )
            .receive(
                "error",
                (msg) => elmApp.ports.incoming_messages.send({
                    "tag": "create_pot_response",
                    "result": msg
                })
            )
            .receive(
                "timeout",
                    () => elmApp.ports.incoming_messages.send({
                        "tag": "create_pot_response",
                        "result": "Timeout Communicating with Server"
                    })
            );
        break;
    case "join_pot_channel":
        if (potChannel) {
            potChannel.leave();
            potChannel = null;
        }
        potChannel = socket.channel("pot:" + value.pot_name, {});
        potChannel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp); })
            .receive("error", resp => { console.log("Unable to join", resp); });

        potChannel.on(
            "set_requests",
            msg =>
                elmApp.ports.incoming_messages.send({
                    "tag": "set_requests",
                    "pot_name": value.pot_name,
                    "requests": msg.requests
                })
        );
        potChannel.on(
            "incoming_request",
            msg =>
                elmApp.ports.incoming_messages.send({
                    "tag": "incoming_request",
                    "pot_name": value.pot_name,
                    "request": msg
                })
        );
        break;
    }
});

lobbyChannel.on('set_requests', data => elmApp.ports.requests.send(data.requests));
