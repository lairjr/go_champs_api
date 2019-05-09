defmodule TournamentsApiWeb.TournamentGroupControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Organizations
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentGroup

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:tournament_group) do
    attrs = map_tournament_id(@create_attrs)
    {:ok, tournament_group} = Tournaments.create_tournament_group(attrs)
    tournament_group
  end

  def map_tournament_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    tournament_attrs = Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})
    {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)

    Map.merge(attrs, %{tournament_id: tournament.id})
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_groups", %{conn: conn} do
      conn = get(conn, Routes.tournament_group_path(conn, :index, "tournament-id"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_group" do
    test "renders tournament_group when data is valid", %{conn: conn} do
      attrs = map_tournament_id(@create_attrs)

      conn =
        post(conn, Routes.tournament_group_path(conn, :create, attrs.tournament_id),
          tournament_group: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_group_path(conn, :show, attrs.tournament_id, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = map_tournament_id(@invalid_attrs)

      conn =
        post(conn, Routes.tournament_group_path(conn, :create, attrs.tournament_id),
          tournament_group: attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_group" do
    setup [:create_tournament_group]

    test "renders tournament_group when data is valid", %{
      conn: conn,
      tournament_group: %TournamentGroup{id: id} = tournament_group
    } do
      conn =
        put(
          conn,
          Routes.tournament_group_path(
            conn,
            :update,
            tournament_group.tournament_id,
            tournament_group
          ),
          tournament_group: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn =
        get(conn, Routes.tournament_group_path(conn, :show, tournament_group.tournament_id, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_group: tournament_group} do
      conn =
        put(
          conn,
          Routes.tournament_group_path(
            conn,
            :update,
            tournament_group.tournament_id,
            tournament_group
          ),
          tournament_group: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_group" do
    setup [:create_tournament_group]

    test "deletes chosen tournament_group", %{conn: conn, tournament_group: tournament_group} do
      conn =
        delete(
          conn,
          Routes.tournament_group_path(
            conn,
            :delete,
            tournament_group.tournament_id,
            tournament_group
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.tournament_group_path(
            conn,
            :show,
            tournament_group.tournament_id,
            tournament_group
          )
        )
      end
    end
  end

  defp create_tournament_group(_) do
    tournament_group = fixture(:tournament_group)
    {:ok, tournament_group: tournament_group}
  end
end
