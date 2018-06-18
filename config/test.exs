use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mxn_usd_exchange, MxnUsdExchangeWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :mxn_usd_exchange, MxnUsdExchange.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "nicolacosta",
  password: "",
  database: "mxn_usd_exchange_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
