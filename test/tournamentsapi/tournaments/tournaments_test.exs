defmodule TournamentsApi.TournamentsTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Organizations

  describe "tournaments" do
    alias TournamentsApi.Tournaments.Tournament

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    @organization_attrs %{name: "some organization name", slug: "some-slug"}

    def tournament_fixture(attrs \\ %{}, organization_attrs \\ @organization_attrs) do
      {:ok, tournament} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_organization_id(organization_attrs)
        |> Tournaments.create_tournament()

      tournament
    end

    def map_organization_id(attrs, organization_attrs) do
      {:ok, %Organizations.Organization{} = organization} =
        Organizations.create_organization(organization_attrs)

      Map.merge(attrs, %{organization_id: organization.id})
    end

    def map_tournament_team_id(attrs \\ %{}) do
      {:ok, tournament_team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_organization_id(@organization_attrs)
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
      tournament_fixture(%{}, %{name: "another organization name", slug: "another-slug"})
      second_tournament = tournament_fixture()
      where = [organization_id: second_tournament.organization_id]
      assert Tournaments.list_tournaments(where) == [second_tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Tournaments.get_tournament!(tournament.id).id == tournament.id
    end

    test "create_tournament/1 with valid data creates a tournament" do
      valid_tournament = map_organization_id(@valid_attrs, @organization_attrs)
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
  end

  describe "tournament_stats" do
    alias TournamentsApi.Tournaments.TournamentStat

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def tournament_stat_fixture(attrs \\ %{}) do
      {:ok, tournament_stat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PhaseHelpers.map_phase_id()
        |> Tournaments.create_tournament_stat()

      tournament_stat
    end

    test "list_tournament_stats/0 returns all tournament_stats" do
      random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      tournament_stat = tournament_stat_fixture()

      [result_stat] = Tournaments.list_tournament_stats(tournament_stat.phase_id)
      assert result_stat.id == tournament_stat.id
      assert Tournaments.list_tournament_stats(random_uuid) == []
    end

    test "get_tournament_stat!/1 returns the tournament_stat with given id" do
      tournament_stat = tournament_stat_fixture()

      result_stat = Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.phase_id)

      assert result_stat.id == tournament_stat.id
    end

    test "create_tournament_stat/1 with valid data creates a tournament_stat" do
      attrs =
        tournament_stat_fixture()
        |> Map.from_struct()

      assert {:ok, %TournamentStat{} = tournament_stat} =
               Tournaments.create_tournament_stat(attrs)

      assert tournament_stat.title == "some title"
    end

    test "create_tournament_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_stat(@invalid_attrs)
    end

    test "update_tournament_stat/2 with valid data updates the tournament_stat" do
      tournament_stat = tournament_stat_fixture()

      attrs = Map.merge(@update_attrs, %{phase_id: tournament_stat.phase_id})

      assert {:ok, %TournamentStat{} = tournament_stat} =
               Tournaments.update_tournament_stat(tournament_stat, attrs)

      assert tournament_stat.title == "some updated title"
    end

    test "update_tournament_stat/2 with invalid data returns error changeset" do
      tournament_stat = tournament_stat_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_stat(tournament_stat, @invalid_attrs)

      result_stat = Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.phase_id)

      assert result_stat.id == tournament_stat.id
    end

    test "delete_tournament_stat/1 deletes the tournament_stat" do
      tournament_stat = tournament_stat_fixture()
      assert {:ok, %TournamentStat{}} = Tournaments.delete_tournament_stat(tournament_stat)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.phase_id)
      end
    end

    test "change_tournament_stat/1 returns a tournament_stat changeset" do
      tournament_stat = tournament_stat_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_stat(tournament_stat)
    end
  end
end
