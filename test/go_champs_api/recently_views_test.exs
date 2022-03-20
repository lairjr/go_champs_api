defmodule GoChampsApi.RecentlyViewsTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.Helpers.TournamentHelpers
  alias GoChampsApi.RecentlyViews

  describe "recently_view" do
    alias GoChampsApi.RecentlyViews.RecentlyView

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def recently_view_fixture(attrs \\ %{}) do
      {:ok, recently_view} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TournamentHelpers.map_tournament_id()
        |> RecentlyViews.create_recently_view()

      recently_view
    end

    test "list_recently_view/0 returns all recently_view" do
      recently_view = recently_view_fixture()
      assert RecentlyViews.list_recently_view() == [recently_view]
    end

    test "get_recently_view!/1 returns the recently_view with given id" do
      recently_view = recently_view_fixture()
      assert RecentlyViews.get_recently_view!(recently_view.id) == recently_view
    end

    test "create_recently_view/1 with valid data creates a recently_view" do
      valid_attrs = TournamentHelpers.map_tournament_id(@valid_attrs)

      assert {:ok, %RecentlyView{} = recently_view} =
               RecentlyViews.create_recently_view(valid_attrs)
    end

    test "create_recently_view/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecentlyViews.create_recently_view(@invalid_attrs)
    end

    test "change_recently_view/1 returns a recently_view changeset" do
      recently_view = recently_view_fixture()
      assert %Ecto.Changeset{} = RecentlyViews.change_recently_view(recently_view)
    end
  end
end
