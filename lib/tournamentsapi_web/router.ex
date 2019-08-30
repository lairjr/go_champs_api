defmodule TournamentsApiWeb.Router do
  use TournamentsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/swagger" do
    forward "/organization", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :tournamentsapi,
      swagger_file: "organization_swagger.json"
  end

  scope "/api", TournamentsApiWeb do
    pipe_through :api

    resources "/games", GameController
    resources "/organizations", OrganizationController
    resources "/teams", TeamController
    resources "/users", UserController
    resources "/phases/:tournament_phase_id/games", TournamentGameController
    resources "/phases/:tournament_phase_id/groups", TournamentGroupController
    resources "/phases/:tournament_phase_id/stats", TournamentStatController
    resources "/tournaments", TournamentController
    resources "/tournaments/:tournament_id/phases", TournamentPhaseController
    resources "/tournaments/:tournament_id/teams", TournamentTeamController
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Go Champs API Docs"
      }
    }
  end
end
