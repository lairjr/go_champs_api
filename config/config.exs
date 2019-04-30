# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tournamentsapi,
  ecto_repos: [Tournamentsapi.Repo]

# Configures the endpoint
config :tournamentsapi, TournamentsapiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "imta0fFj1/DTKBsA9UFU4NP9/3U2KQAAi9TqID70AdjSC1sBxS8D1ddhrkRAHP5X",
  render_errors: [view: TournamentsapiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Tournamentsapi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
