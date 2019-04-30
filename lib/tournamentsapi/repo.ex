defmodule Tournamentsapi.Repo do
  use Ecto.Repo,
    otp_app: :tournamentsapi,
    adapter: Ecto.Adapters.Postgres
end
