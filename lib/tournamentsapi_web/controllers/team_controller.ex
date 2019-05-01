defmodule TournamentsApiWeb.TeamController do
  use TournamentsApiWeb, :controller

  def index(conn, _params) do
    teams = [%{id: "team-one", name: "Panteras", link: "panteras-poa"},%{id: "team-two", name: "Illumis", link: "illumis"}]
    json(conn, teams)
  end
end