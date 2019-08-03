defmodule TournamentsApiWeb.TournamentTeamController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentTeam

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_id" => tournament_id}) do
    tournament_teams = Tournaments.list_tournament_teams(tournament_id)
    render(conn, "index.json", tournament_teams: tournament_teams)
  end

  def create(conn, %{
        "tournament_team" => tournament_team_params,
        "tournament_id" => tournament_id
      }) do
    tournament_team_params =
      Map.merge(tournament_team_params, %{"tournament_id" => tournament_id})

    with {:ok, %TournamentTeam{} = created_tournament_team} <-
           Tournaments.create_tournament_team(tournament_team_params) do
      tournament_team =
        Tournaments.get_tournament_team!(created_tournament_team.id, tournament_id)

      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_team_path(conn, :show, tournament_id, tournament_team)
      )
      |> render("show.json", tournament_team: tournament_team)
    end
  end

  def show(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_team = Tournaments.get_tournament_team!(id, tournament_id)
    render(conn, "show.json", tournament_team: tournament_team)
  end

  def update(conn, %{
        "id" => id,
        "tournament_team" => tournament_team_params,
        "tournament_id" => tournament_id
      }) do
    tournament_team = Tournaments.get_tournament_team!(id, tournament_id)

    with {:ok, %TournamentTeam{} = tournament_team} <-
           Tournaments.update_tournament_team(tournament_team, tournament_team_params) do
      render(conn, "show.json", tournament_team: tournament_team)
    end
  end

  def delete(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_team = Tournaments.get_tournament_team!(id, tournament_id)

    with {:ok, %TournamentTeam{}} <- Tournaments.delete_tournament_team(tournament_team) do
      send_resp(conn, :no_content, "")
    end
  end
end
