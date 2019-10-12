defmodule TournamentsApiWeb.TournamentStatController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentStat

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"phase_id" => phase_id}) do
    tournament_stats = Tournaments.list_tournament_stats(phase_id)
    render(conn, "index.json", tournament_stats: tournament_stats)
  end

  def create(conn, %{
        "tournament_stat" => tournament_stat_params,
        "phase_id" => phase_id
      }) do
    tournament_stat_params = Map.merge(tournament_stat_params, %{"phase_id" => phase_id})

    with {:ok, %TournamentStat{} = tournament_stat} <-
           Tournaments.create_tournament_stat(tournament_stat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_stat_path(conn, :show, phase_id, tournament_stat)
      )
      |> render("show.json", tournament_stat: tournament_stat)
    end
  end

  def show(conn, %{"id" => id, "phase_id" => phase_id}) do
    tournament_stat = Tournaments.get_tournament_stat!(id, phase_id)
    render(conn, "show.json", tournament_stat: tournament_stat)
  end

  def update(conn, %{
        "id" => id,
        "tournament_stat" => tournament_stat_params,
        "phase_id" => phase_id
      }) do
    tournament_stat = Tournaments.get_tournament_stat!(id, phase_id)

    with {:ok, %TournamentStat{} = tournament_stat} <-
           Tournaments.update_tournament_stat(tournament_stat, tournament_stat_params) do
      render(conn, "show.json", tournament_stat: tournament_stat)
    end
  end

  def delete(conn, %{"id" => id, "phase_id" => phase_id}) do
    tournament_stat = Tournaments.get_tournament_stat!(id, phase_id)

    with {:ok, %TournamentStat{}} <- Tournaments.delete_tournament_stat(tournament_stat) do
      send_resp(conn, :no_content, "")
    end
  end
end
