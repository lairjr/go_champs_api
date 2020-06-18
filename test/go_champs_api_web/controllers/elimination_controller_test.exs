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

  def fixture(:elimination_with_different_member) do
    {:ok, elimination} =
      @create_attrs
      |> PhaseHelpers.map_phase_id_with_other_member()
      |> Eliminations.create_elimination()

    elimination
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create elimination" do
    @tag :authenticated
    test "renders elimination when data is valid", %{conn: conn} do
      create_attrs = PhaseHelpers.map_phase_id(@create_attrs)
      conn = post(conn, Routes.v1_elimination_path(conn, :create), elimination: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_elimination_path(conn, :show, id))

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

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = PhaseHelpers.map_phase_id(@invalid_attrs)
      conn = post(conn, Routes.v1_elimination_path(conn, :create), elimination: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create elimination with different organization member" do
    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{conn: conn} do
      attrs = PhaseHelpers.map_phase_id_with_other_member(@create_attrs)

      conn = post(conn, Routes.v1_elimination_path(conn, :create), elimination: attrs)

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  describe "update elimination" do
    setup [:create_elimination]

    @tag :authenticated
    test "renders elimination when data is valid", %{
      conn: conn,
      elimination: %Elimination{id: id} = elimination
    } do
      conn =
        put(conn, Routes.v1_elimination_path(conn, :update, elimination),
          elimination: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_elimination_path(conn, :show, id))

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

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, elimination: elimination} do
      conn =
        put(conn, Routes.v1_elimination_path(conn, :update, elimination),
          elimination: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update elimination with different member" do
    setup [:create_elimination_with_different_member]

    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{
      conn: conn,
      elimination: elimination
    } do
      conn =
        put(
          conn,
          Routes.v1_elimination_path(
            conn,
            :update,
            elimination
          ),
          elimination: @update_attrs
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  describe "batch update elimination" do
    setup %{conn: conn} do
      first_elimination = fixture(:elimination)
      attrs = Map.merge(@create_attrs, %{phase_id: first_elimination.phase_id})
      {:ok, second_elimination} = Eliminations.create_elimination(attrs)
      {:ok, conn: conn, eliminations: [first_elimination, second_elimination]}
    end

    @tag :authenticated
    test "renders eliminations when data is valid", %{
      conn: conn,
      eliminations: [first_elimination, second_elimination]
    } do
      first_elimination_update =
        Map.merge(%{id: first_elimination.id}, %{title: "first title updated"})

      second_elimination_update =
        Map.merge(%{id: second_elimination.id}, %{title: "second title updated"})

      eliminations = [first_elimination_update, second_elimination_update]

      conn =
        patch(
          conn,
          Routes.v1_elimination_path(
            conn,
            :batch_update
          ),
          eliminations: eliminations
        )

      first_elimination_id = first_elimination.id
      second_elimination_id = second_elimination.id

      %{
        ^first_elimination_id => first_elimination_result,
        ^second_elimination_id => second_elimination_result
      } = json_response(conn, 200)["data"]

      assert first_elimination_result["id"] == first_elimination.id
      assert first_elimination_result["title"] == "first title updated"
      assert second_elimination_result["id"] == second_elimination.id
      assert second_elimination_result["title"] == "second title updated"
    end
  end

  describe "batch update elimination with different member" do
    setup [:create_elimination_with_different_member]

    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{
      conn: conn,
      elimination: elimination
    } do
      elimination_update = Map.merge(%{id: elimination.id}, %{title: "title updated"})

      conn =
        patch(
          conn,
          Routes.v1_elimination_path(
            conn,
            :batch_update
          ),
          eliminations: [elimination_update]
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  describe "delete elimination" do
    setup [:create_elimination]

    @tag :authenticated
    test "deletes chosen elimination", %{conn: conn, elimination: elimination} do
      conn = delete(conn, Routes.v1_elimination_path(conn, :delete, elimination))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_elimination_path(conn, :show, elimination))
      end
    end
  end

  describe "delete elimination with different member" do
    setup [:create_elimination_with_different_member]

    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{
      conn: conn,
      elimination: elimination
    } do
      conn =
        delete(
          conn,
          Routes.v1_elimination_path(
            conn,
            :delete,
            elimination
          )
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  defp create_elimination(_) do
    elimination = fixture(:elimination)
    {:ok, elimination: elimination}
  end

  defp create_elimination_with_different_member(_) do
    elimination = fixture(:elimination_with_different_member)
    {:ok, elimination: elimination}
  end
end
