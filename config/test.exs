use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tournamentsapi, TournamentsApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
# Configure your database
config :tournamentsapi, TournamentsApi.Repo,
  username: "postgres",
  password: "admin",
  database: "tournaments",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
