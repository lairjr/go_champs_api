defmodule TournamentsApiWeb.TournamentTeamStatController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentTeamStat

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_team_id" => tournament_team_id}) do
    tournament_team_stats = Tournaments.list_tournament_team_stats(tournament_team_id)
    render(conn, "index.json", tournament_team_stats: tournament_team_stats)
  end

  def create(conn, %{
        "tournament_team_stat" => tournament_team_stat_params,
        "tournament_team_id" => tournament_team_id
      }) do
    tournament_team_stat_params =
      Map.merge(tournament_team_stat_params, %{"tournament_team_id" => tournament_team_id})

    with {:ok, %TournamentTeamStat{} = tournament_team_stat} <-
           Tournaments.create_tournament_team_stat(tournament_team_stat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_team_stat_path(conn, :show, tournament_team_id, tournament_team_stat)
      )
      |> render("show.json", tournament_team_stat: tournament_team_stat)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament_team_stat = Tournaments.get_tournament_team_stat!(id)
    render(conn, "show.json", tournament_team_stat: tournament_team_stat)
  end

  def update(conn, %{"id" => id, "tournament_team_stat" => tournament_team_stat_params}) do
    tournament_team_stat = Tournaments.get_tournament_team_stat!(id)

    with {:ok, %TournamentTeamStat{} = tournament_team_stat} <-
           Tournaments.update_tournament_team_stat(
             tournament_team_stat,
             tournament_team_stat_params
           ) do
      render(conn, "show.json", tournament_team_stat: tournament_team_stat)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament_team_stat = Tournaments.get_tournament_team_stat!(id)

    with {:ok, %TournamentTeamStat{}} <-
           Tournaments.delete_tournament_team_stat(tournament_team_stat) do
      send_resp(conn, :no_content, "")
    end
  end
end
