defmodule TournamentsApi.TournamentsTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Helpers.OrganizationHelpers
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Organizations

  describe "tournaments" do
    alias TournamentsApi.Tournaments.Tournament

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tournament_fixture(attrs \\ %{}) do
      {:ok, tournament} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OrganizationHelpers.map_organization_id()
        |> Tournaments.create_tournament()

      tournament
    end

    def map_tournament_team_id(attrs \\ %{}) do
      {:ok, tournament_team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OrganizationHelpers.map_organization_id()
        |> Tournaments.create_tournament()
        |> map_tournament_team()
        |> Tournaments.create_tournament_team()

      Map.merge(attrs, %{tournament_team_id: tournament_team.id})
    end

    def map_tournament_team({:ok, tournament}) do
      %{name: "some team name", tournament_id: tournament.id}
    end

    test "list_tournaments/0 returns all tournaments" do
      tournament = tournament_fixture()
      assert Tournaments.list_tournaments() == [tournament]
    end

    test "list_tournaments/1 returns all tournaments pertaining to some organization" do
      {:ok, another_organization} =
        Organizations.create_organization(%{name: "another organization", slug: "another-slug"})

      @valid_attrs
      |> Map.merge(%{organization_id: another_organization.id})
      |> Tournaments.create_tournament()

      second_tournament = tournament_fixture()
      where = [organization_id: second_tournament.organization_id]
      assert Tournaments.list_tournaments(where) == [second_tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Tournaments.get_tournament!(tournament.id).id == tournament.id
    end

    test "create_tournament/1 with valid data creates a tournament" do
      valid_tournament = OrganizationHelpers.map_organization_id(@valid_attrs)
      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(valid_tournament)
    end

    test "create_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament(@invalid_attrs)
    end

    test "update_tournament/2 with valid data updates the tournament" do
      tournament = tournament_fixture()

      assert {:ok, %Tournament{} = tournament} =
               Tournaments.update_tournament(tournament, @update_attrs)
    end

    test "update_tournament/2 with invalid data returns error changeset" do
      tournament = tournament_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament(tournament, @invalid_attrs)

      assert tournament.id == Tournaments.get_tournament!(tournament.id).id
    end

    test "delete_tournament/1 deletes the tournament" do
      tournament = tournament_fixture()
      assert {:ok, %Tournament{}} = Tournaments.delete_tournament(tournament)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament!(tournament.id) end
    end

    test "change_tournament/1 returns a tournament changeset" do
      tournament = tournament_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament(tournament)
    end

    test "search_tournaments/1 returns all tournaments matching common term" do
      {:ok, another_organization} =
        Organizations.create_organization(%{name: "another organization", slug: "another-slug"})

      {:ok, first_tournament} =
        %{name: "another name"}
        |> Map.merge(%{organization_id: another_organization.id})
        |> Tournaments.create_tournament()

      second_tournament = tournament_fixture()

      term = "name"

      [first_result, second_result] = Tournaments.search_tournaments(term)

      assert first_result.id == first_tournament.id
      assert second_result.id == second_tournament.id
    end

    test "search_tournaments/1 returns all tournaments matching second tournament term" do
      {:ok, another_organization} =
        Organizations.create_organization(%{name: "another organization", slug: "another-slug"})

      {:ok, first_tournament} =
        %{name: "another name"}
        |> Map.merge(%{organization_id: another_organization.id})
        |> Tournaments.create_tournament()

      tournament_fixture()

      term = "another"

      [first_result] = Tournaments.search_tournaments(term)

      assert first_result.id == first_tournament.id
    end
  end
end
