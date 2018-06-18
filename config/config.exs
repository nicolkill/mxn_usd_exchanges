# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mxn_usd_exchange,
  ecto_repos: [MxnUsdExchange.Repo]

# Configures the endpoint
config :mxn_usd_exchange, MxnUsdExchangeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "E3AO2KAuAAUqUjrQvkbBXlZgYX+WjYep+KF9mKYvbYVyLoN3fKyRrMFlEweBL4WX",
  render_errors: [view: MxnUsdExchangeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MxnUsdExchange.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
