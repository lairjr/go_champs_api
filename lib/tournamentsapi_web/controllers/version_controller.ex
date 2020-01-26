defmodule TournamentsApiWeb.VersionController do
  use TournamentsApiWeb, :controller

  def index(conn, _params) do
    revision = System.get_env("HEROKU_RELEASE_VERSION") || "0"
    version = %{version: "0.0." <> revision}

    json(conn, version)
  end
end
