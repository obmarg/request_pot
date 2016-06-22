# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :request_pot, RequestPot.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "joE0OH8LBIxiYwLioKARsecbhZMCBSbcwghL1OA8ZBLsCT4tSuZb8s7fxQYgoAW2",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: RequestPot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :exometer_datadog,
  api_key: {:system, "DATADOG_API_KEY"},
  report_vm_metrics: true,
  report_system_metrics: true,
  metric_prefix: [:request_pot, Mix.env]

config :elixometer,
  reporter: ExometerDatadog.Reporter,
  env: Mix.env,
  metric_prefix: "request_pot",
  update_frequency: 1000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
