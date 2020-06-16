defmodule GoChampsApiWeb.TeamController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Teams
  alias GoChampsApi.Teams.Team

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedTeam, :id when action in [:delete, :update]
  plug GoChampsApiWeb.Plugs.AuthorizedTeam, :team when action in [:create]

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
