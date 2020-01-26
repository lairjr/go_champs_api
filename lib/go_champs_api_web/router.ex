defmodule GoChampsApiWeb.Router do
  use GoChampsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/swagger" do
    forward "/organization", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :go_champs_api,
      swagger_file: "organization_swagger.json"
  end

  scope "/api", GoChampsApiWeb do
    pipe_through :api

    resources "/draws", DrawController
    resources "/eliminations", EliminationController
    resources "/games", GameController
    resources "/organizations", OrganizationController
    resources "/phases", PhaseController
    get "/search", SearchController, :index
    resources "/users", UserController
    resources "/teams", TeamController
    resources "/tournaments", TournamentController
    get "/version", VersionController, :index
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