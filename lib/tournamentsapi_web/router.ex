defmodule TournamentsapiWeb.Router do
  use TournamentsapiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TournamentsapiWeb do
    pipe_through :api

    resources "/games", GameController
    resources "/users", UserController
    resources "/teams", TeamController
    resources "/tournaments", TournamentController
  end
end
