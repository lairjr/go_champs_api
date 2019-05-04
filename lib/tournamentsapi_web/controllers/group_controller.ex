defmodule TournamentsApiWeb.GroupController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.Group

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_id" => tournament_id}) do
    groups = Tournaments.list_groups(tournament_id)
    render(conn, "index.json", groups: groups)
  end

  def create(conn, %{"group" => group_params, "tournament_id" => tournament_id}) do
    group_params = Map.merge(group_params, %{"tournament_id" => tournament_id})

    with {:ok, %Group{} = group} <- Tournaments.create_group(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.group_path(conn, :show, tournament_id, group))
      |> render("show.json", group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Tournaments.get_group!(id)
    render(conn, "show.json", group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Tournaments.get_group!(id)

    with {:ok, %Group{} = group} <- Tournaments.update_group(group, group_params) do
      render(conn, "show.json", group: group)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Tournaments.get_group!(id)

    with {:ok, %Group{}} <- Tournaments.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
