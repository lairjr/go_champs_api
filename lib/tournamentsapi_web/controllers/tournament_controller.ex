defmodule TournamentsApiWeb.TournamentController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.Tournament

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, _params) do
    tournaments = Tournaments.list_tournaments()
    render(conn, "index.json", tournaments: tournaments)
  end

  def create(conn, %{"tournament" => tournament_params}) do
    with {:ok, %Tournament{} = tournament} <- Tournaments.create_tournament(tournament_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tournament_path(conn, :show, tournament))
      |> render("show.json", tournament: tournament)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    render(conn, "show.json", tournament: tournament)
  end

  def update(conn, %{"id" => id, "tournament" => tournament_params}) do
    tournament = Tournaments.get_tournament!(id)

    with {:ok, %Tournament{} = tournament} <-
           Tournaments.update_tournament(tournament, tournament_params) do
      render(conn, "show.json", tournament: tournament)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)

    with {:ok, %Tournament{}} <- Tournaments.delete_tournament(tournament) do
      send_resp(conn, :no_content, "")
    end
  end
end
