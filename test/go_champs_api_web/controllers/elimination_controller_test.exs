defmodule GoChampsApiWeb.EliminationControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Helpers.PhaseHelpers
  alias GoChampsApi.Eliminations
  alias GoChampsApi.Eliminations.Elimination

  random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"

  @create_attrs %{
    title: "some title",
    info: "some info",
    team_stats: [%{placeholder: "placeholder", team_id: random_uuid, stats: %{"key" => "value"}}]
  }
  @update_attrs %{
    title: "some updated title",
    info: "some updated info",
    team_stats: [
      %{placeholder: "placeholder updated", team_id: random_uuid, stats: %{"key" => "updated"}}
    ]
  }
  @invalid_attrs %{team_stats: nil}

  def fixture(:elimination) do
    create_attrs = PhaseHelpers.map_phase_id(@create_attrs)
    {:ok, elimination} = Eliminations.create_elimination(create_attrs)
    elimination
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create elimination" do
    test "renders elimination when data is valid", %{conn: conn} do
      create_attrs = PhaseHelpers.map_phase_id(@create_attrs)
      conn = post(conn, Routes.elimination_path(conn, :create), elimination: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.elimination_path(conn, :show, id))

      %{
        "id" => result_id,
        "title" => result_title,
        "info" => result_info,
        "order" => result_order,
        "team_stats" => [team_stat]
      } = json_response(conn, 200)["data"]

      assert result_id == id
      assert result_title == "some title"
      assert result_info == "some info"
      assert result_order == 1
      assert team_stat["stats"] == %{"key" => "value"}
      assert team_stat["placeholder"] == "placeholder"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = PhaseHelpers.map_phase_id(@invalid_attrs)
      conn = post(conn, Routes.elimination_path(conn, :create), elimination: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update elimination" do
    setup [:create_elimination]

    test "renders elimination when data is valid", %{
      conn: conn,
      elimination: %Elimination{id: id} = elimination
    } do
      conn =
        put(conn, Routes.elimination_path(conn, :update, elimination), elimination: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.elimination_path(conn, :show, id))

      %{
        "id" => result_id,
        "title" => result_title,
        "info" => result_info,
        "order" => result_order,
        "team_stats" => [team_stat]
      } = json_response(conn, 200)["data"]

      assert result_id == id
      assert result_title == "some updated title"
      assert result_info == "some updated info"
      assert result_order == 1
      assert team_stat["stats"] == %{"key" => "updated"}
      assert team_stat["placeholder"] == "placeholder updated"
    end

    test "renders errors when data is invalid", %{conn: conn, elimination: elimination} do
      conn =
        put(conn, Routes.elimination_path(conn, :update, elimination), elimination: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete elimination" do
    setup [:create_elimination]

    test "deletes chosen elimination", %{conn: conn, elimination: elimination} do
      conn = delete(conn, Routes.elimination_path(conn, :delete, elimination))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.elimination_path(conn, :show, elimination))
      end
    end
  end

  defp create_elimination(_) do
    elimination = fixture(:elimination)
    {:ok, elimination: elimination}
  end
end
