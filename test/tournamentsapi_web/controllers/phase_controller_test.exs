defmodule TournamentsApiWeb.PhaseControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Helpers.TournamentHelpers
  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.Phase

  @create_attrs %{
    title: "some title",
    type: "elimination"
  }
  @update_attrs %{
    title: "some updated title",
    type: "elimination"
  }
  @invalid_attrs %{title: nil, type: nil}

  def fixture(:phase) do
    attrs = TournamentHelpers.map_tournament_id(@create_attrs)
    {:ok, phase} = Phases.create_phase(attrs)
    phase
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create phase" do
    test "renders phase when data is valid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id(@create_attrs)

      conn = post(conn, Routes.phase_path(conn, :create), phase: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.phase_path(conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some title",
               "type" => "elimination"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id(@invalid_attrs)

      conn = post(conn, Routes.phase_path(conn, :create), phase: attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update phase" do
    setup [:create_phase]

    test "renders phase when data is valid", %{
      conn: conn,
      phase: %Phase{id: id} = phase
    } do
      conn =
        put(
          conn,
          Routes.phase_path(
            conn,
            :update,
            phase
          ),
          phase: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.phase_path(conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some updated title",
               "type" => "elimination"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, phase: phase} do
      conn =
        put(
          conn,
          Routes.phase_path(
            conn,
            :update,
            phase
          ),
          phase: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete phase" do
    setup [:create_phase]

    test "deletes chosen phase", %{conn: conn, phase: phase} do
      conn =
        delete(
          conn,
          Routes.phase_path(
            conn,
            :delete,
            phase
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.phase_path(
            conn,
            :show,
            phase
          )
        )
      end
    end
  end

  defp create_phase(_) do
    phase = fixture(:phase)
    {:ok, phase: phase}
  end
end
