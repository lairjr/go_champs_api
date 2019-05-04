defmodule TournamentsApiWeb.Router do
  use TournamentsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TournamentsApiWeb do
    pipe_through :api

    resources "/games", GameController
    resources "/users", UserController
    resources "/teams", TeamController
    resources "/tournaments", TournamentController
    resources "/tournaments/:tournament_id/groups", TournamentGroupController
    resources "/tournaments/:tournament_id/teams", TournamentTeamController
  end
end
