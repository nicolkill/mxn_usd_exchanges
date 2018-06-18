use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :mxn_usd_exchange, MxnUsdExchangeWeb.Endpoint,
  secret_key_base: "Z6SqIjwG/vxaDFQvR/1urWx3LWWf0szKEcUvEew7W+QNHHTmOK/31D+umKx5UpqH"

# Configure your database
config :mxn_usd_exchange, MxnUsdExchange.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "mxn_usd_exchange_prod",
  pool_size: 15
