use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :store_finder, StoreFinderWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :store_finder, StoreFinder.Repo,
  username: "postgres",
  password: "postgres",
  database: "store_finder_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
