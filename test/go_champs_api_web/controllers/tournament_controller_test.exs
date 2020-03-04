defmodule GoChampsApiWeb.TournamentControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Organizations
  alias GoChampsApi.Tournaments
  alias GoChampsApi.Tournaments.Tournament

  @create_attrs %{
    name: "some name",
    slug: "some-slug",
    facebook: "facebook",
    instagram: "instagram",
    site_url: "site url",
    twitter: "twitter"
  }
  @update_attrs %{
    name: "some updated name",
    slug: "some-updated-slug",
    facebook: "facebook updated",
    instagram: "instagram updated",
    site_url: "site url updated",
    twitter: "twitter updated"
  }
  @invalid_attrs %{name: nil}

  @organization_attrs %{name: "some organization", slug: "some-org-slug"}

  def fixture(:tournament, organization_params \\ @organization_attrs) do
    {:ok, organization} = Organizations.create_organization(organization_params)

    attrs = Map.merge(@create_attrs, %{organization_id: organization.id})
    {:ok, tournament} = Tournaments.create_tournament(attrs)
    tournament
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournaments", %{conn: conn} do
      conn = get(conn, Routes.tournament_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all tournaments matching where", %{conn: conn} do
      fixture(:tournament)

      second_tournament =
        fixture(:tournament, %{name: "another organization", slug: "another-org-slug"})

      where = %{"organization_id" => second_tournament.organization_id}

      conn = get(conn, Routes.tournament_path(conn, :index, where: where))
      [tournament_result] = json_response(conn, 200)["data"]
      assert tournament_result["id"] == second_tournament.id
    end
  end

  describe "create tournament" do
    test "renders tournament when data is valid", %{conn: conn} do
      {:ok, organization} =
        Organizations.create_organization(%{name: "some organization", slug: "some-org-slug"})

      attrs = Map.merge(@create_attrs, %{organization_id: organization.id})

      conn = post(conn, Routes.tournament_path(conn, :create), tournament: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => result_name,
               "slug" => result_slug,
               "facebook" => result_facebook,
               "instagram" => result_instagram,
               "site_url" => result_site,
               "twitter" => result_twitter
             } = json_response(conn, 200)["data"]

      assert result_name == "some name"
      assert result_slug == "some-slug"
      assert result_facebook == "facebook"
      assert result_instagram == "instagram"
      assert result_site == "site url"
      assert result_twitter == "twitter"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tournament_path(conn, :create), tournament: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament" do
    setup [:create_tournament]

    test "renders tournament when data is valid", %{
      conn: conn,
      tournament: %Tournament{id: id} = tournament
    } do
      conn =
        put(conn, Routes.tournament_path(conn, :update, tournament), tournament: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => result_name,
               "slug" => result_slug,
               "facebook" => result_facebook,
               "instagram" => result_instagram,
               "site_url" => result_site,
               "twitter" => result_twitter
             } = json_response(conn, 200)["data"]

      assert result_name == "some updated name"
      assert result_slug == "some-updated-slug"
      assert result_facebook == "facebook updated"
      assert result_instagram == "instagram updated"
      assert result_site == "site url updated"
      assert result_twitter == "twitter updated"
    end

    test "renders errors when data is invalid", %{conn: conn, tournament: tournament} do
      conn =
        put(conn, Routes.tournament_path(conn, :update, tournament), tournament: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament" do
    setup [:create_tournament]

    test "deletes chosen tournament", %{conn: conn, tournament: tournament} do
      conn = delete(conn, Routes.tournament_path(conn, :delete, tournament))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tournament_path(conn, :show, tournament))
      end
    end
  end

  defp create_tournament(_) do
    tournament = fixture(:tournament)
    {:ok, tournament: tournament}
  end
end
