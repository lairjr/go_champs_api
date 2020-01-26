defmodule GoChampsApiWeb.TournamentController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Tournaments
  alias GoChampsApi.Tournaments.Tournament

  action_fallback GoChampsApiWeb.FallbackController

  defp map_to_keyword(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
  end

  def index(conn, params) do
    tournaments =
      case params do
        %{"where" => where} ->
          where
          |> map_to_keyword()
          |> Tournaments.list_tournaments()

        _ ->
          Tournaments.list_tournaments()
      end

    render(conn, "index.json", tournaments: tournaments)
  end

  def create(conn, %{"tournament" => tournament_params}) do
    with {:ok, %Tournament{} = created_tournament} <-
           Tournaments.create_tournament(tournament_params) do
      tournament = Tournaments.get_tournament!(created_tournament.id)

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
