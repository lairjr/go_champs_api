defmodule GoChampsApiWeb.Router do
  use GoChampsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug GoChampsApiWeb.Auth.Pipeline
  end

  scope "/api/swagger" do
    forward "/organization", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :go_champs_api,
      swagger_file: "organization_swagger.json"
  end

  scope "/api", GoChampsApiWeb do
    pipe_through :api

    resources "/draws", DrawController
    patch "/draws", DrawController, :batch_update
    resources "/eliminations", EliminationController
    patch "/eliminations", EliminationController, :batch_update
    resources "/games", GameController
    resources "/organizations", OrganizationController
    resources "/phases", PhaseController
    patch "/phases", PhaseController, :batch_update
    get "/search", SearchController, :index
    patch "/users", UserController, :update
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
    resources "/teams", TeamController
    resources "/tournaments", TournamentController
    get "/version", VersionController, :index
  end

  scope "/v1", GoChampsApiWeb, as: :v1 do
    pipe_through :api

    resources "/aggregated-player-stats-by-tournament",
              AggregatedPlayerStatsByTournamentController,
              only: [:index, :show]

    resources "/draws", DrawController, only: [:show]

    resources "/eliminations", EliminationController, only: [:show]

    resources "/games", GameController, only: [:index, :show]

    resources "/organizations", OrganizationController, only: [:index, :show]

    resources "/phases", PhaseController, only: [:show]

    resources "/players", PlayerController, only: [:show]

    resources "/player-stats-logs", PlayerStatsLogController, only: [:index, :show]

    get "/search", SearchController, :index

    resources "/teams", TeamController, only: [:show]

    resources "/tournaments", TournamentController, only: [:index, :show]

    post "/accounts/signup", UserController, :create
    post "/accounts/facebook-signup", UserController, :create_with_facebook
    post "/accounts/signin", UserController, :signin
    post "/accounts/facebook-signin", UserController, :signin_with_facebook
    post "/accounts/recovery", UserController, :recovey_account
    post "/accounts/reset", UserController, :reset_password

    get "/version", VersionController, :index
  end

  scope "/v1", GoChampsApiWeb, as: :v1 do
    pipe_through [:api, :auth]

    resources "/draws", DrawController, only: [:create, :update, :delete]
    patch "/draws", DrawController, :batch_update

    resources "/eliminations", EliminationController, only: [:create, :update, :delete]
    patch "/eliminations", EliminationController, :batch_update

    resources "/games", GameController, only: [:create, :update, :delete]

    resources "/organizations", OrganizationController, only: [:create, :update, :delete]

    patch "/phases", PhaseController, :batch_update
    resources "/phases", PhaseController, only: [:create, :update, :delete]

    resources "/players", PlayerController, only: [:create, :update, :delete]

    resources "/player-stats-logs", PlayerStatsLogController, only: [:create, :update, :delete]
    patch "/player-stats-logs", PlayerStatsLogController, :batch_update

    resources "/teams", TeamController, only: [:create, :update, :delete]

    resources "/tournaments", TournamentController, only: [:create, :update, :delete]

    get "/users/:username", UserController, :show
    patch "/users", UserController, :update
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
