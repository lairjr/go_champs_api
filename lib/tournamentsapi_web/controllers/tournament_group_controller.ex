defmodule TournamentsApiWeb.TournamentGroupController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentGroup

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_id" => tournament_id}) do
    tournament_groups = Tournaments.list_tournament_groups(tournament_id)
    render(conn, "index.json", tournament_groups: tournament_groups)
  end

  def create(conn, %{
        "tournament_group" => tournament_group_params,
        "tournament_id" => tournament_id
      }) do
    tournament_group_params =
      Map.merge(tournament_group_params, %{"tournament_id" => tournament_id})

    with {:ok, %TournamentGroup{} = tournament_group} <-
           Tournaments.create_tournament_group(tournament_group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_group_path(conn, :show, tournament_id, tournament_group)
      )
      |> render("show.json", tournament_group: tournament_group)
    end
  end

  def show(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_group = Tournaments.get_tournament_group!(id, tournament_id)
    render(conn, "show.json", tournament_group: tournament_group)
  end

  def update(conn, %{
        "id" => id,
        "tournament_group" => tournament_group_params,
        "tournament_id" => tournament_id
      }) do
    tournament_group = Tournaments.get_tournament_group!(id, tournament_id)

    with {:ok, %TournamentGroup{} = tournament_group} <-
           Tournaments.update_tournament_group(tournament_group, tournament_group_params) do
      render(conn, "show.json", tournament_group: tournament_group)
    end
  end

  def delete(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_group = Tournaments.get_tournament_group!(id, tournament_id)

    with {:ok, %TournamentGroup{}} <- Tournaments.delete_tournament_group(tournament_group) do
      send_resp(conn, :no_content, "")
    end
  end
end
