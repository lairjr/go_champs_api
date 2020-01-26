defmodule GoChampsApiWeb.DrawControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Draws
  alias GoChampsApi.Draws.Draw
  alias GoChampsApi.Helpers.PhaseHelpers

  @create_attrs %{
    title: "some title",
    matches: [
      %{
        first_team_placeholder: "some-first-team-placeholder",
        second_team_placeholder: "some-second-team-placeholder"
      }
    ]
  }
  @update_attrs %{
    title: "some updated title",
    matches: [
      %{
        first_team_placeholder: "some-updated-first-team-placeholder",
        second_team_placeholder: "some-updated-second-team-placeholder"
      }
    ]
  }
  @invalid_attrs %{title: nil, matches: nil}

  def fixture(:draw) do
    draw_attrs = PhaseHelpers.map_phase_id(@create_attrs)
    {:ok, draw} = Draws.create_draw(draw_attrs)
    draw
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create draw" do
    test "renders draw when data is valid", %{conn: conn} do
      create_attrs = PhaseHelpers.map_phase_id(@create_attrs)
      conn = post(conn, Routes.draw_path(conn, :create), draw: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.draw_path(conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.draw_path(conn, :create), draw: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update draw" do
    setup [:create_draw]

    test "renders draw when data is valid", %{conn: conn, draw: %Draw{id: id} = draw} do
      conn = put(conn, Routes.draw_path(conn, :update, draw), draw: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.draw_path(conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, draw: draw} do
      conn = put(conn, Routes.draw_path(conn, :update, draw), draw: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete draw" do
    setup [:create_draw]

    test "deletes chosen draw", %{conn: conn, draw: draw} do
      conn = delete(conn, Routes.draw_path(conn, :delete, draw))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.draw_path(conn, :show, draw))
      end
    end
  end

  defp create_draw(_) do
    draw = fixture(:draw)
    {:ok, draw: draw}
  end
end
