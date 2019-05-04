defmodule TournamentsApi.TournamentsTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Tournaments

  describe "tournaments" do
    alias TournamentsApi.Tournaments.Tournament

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def tournament_fixture(attrs \\ %{}) do
      {:ok, tournament} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_tournament()

      tournament
    end

    test "list_tournaments/0 returns all tournaments" do
      tournament = tournament_fixture()
      assert Tournaments.list_tournaments() == [tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Tournaments.get_tournament!(tournament.id) == tournament
    end

    test "create_tournament/1 with valid data creates a tournament" do
      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(@valid_attrs)
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

      assert tournament == Tournaments.get_tournament!(tournament.id)
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

  describe "tournament_groups" do
    alias TournamentsApi.Tournaments.TournamentGroup

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tournament_group_fixture(attrs \\ %{}) do
      {:ok, tournament_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_tournament_group()

      tournament_group
    end

    test "list_tournament_groups/0 returns all tournament_groups" do
      tournament_group = tournament_group_fixture()
      assert Tournaments.list_tournament_groups() == [tournament_group]
    end

    test "get_tournament_group!/1 returns the tournament_group with given id" do
      tournament_group = tournament_group_fixture()
      assert Tournaments.get_tournament_group!(tournament_group.id) == tournament_group
    end

    test "create_tournament_group/1 with valid data creates a tournament_group" do
      assert {:ok, %TournamentGroup{} = tournament_group} = Tournaments.create_tournament_group(@valid_attrs)
      assert tournament_group.name == "some name"
    end

    test "create_tournament_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_group(@invalid_attrs)
    end

    test "update_tournament_group/2 with valid data updates the tournament_group" do
      tournament_group = tournament_group_fixture()
      assert {:ok, %TournamentGroup{} = tournament_group} = Tournaments.update_tournament_group(tournament_group, @update_attrs)
      assert tournament_group.name == "some updated name"
    end

    test "update_tournament_group/2 with invalid data returns error changeset" do
      tournament_group = tournament_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_tournament_group(tournament_group, @invalid_attrs)
      assert tournament_group == Tournaments.get_tournament_group!(tournament_group.id)
    end

    test "delete_tournament_group/1 deletes the tournament_group" do
      tournament_group = tournament_group_fixture()
      assert {:ok, %TournamentGroup{}} = Tournaments.delete_tournament_group(tournament_group)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament_group!(tournament_group.id) end
    end

    test "change_tournament_group/1 returns a tournament_group changeset" do
      tournament_group = tournament_group_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_group(tournament_group)
    end
  end

  describe "tournament_teams" do
    alias TournamentsApi.Tournaments.TournamentTeam

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tournament_team_fixture(attrs \\ %{}) do
      {:ok, tournament_team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_tournament_team()

      tournament_team
    end

    test "list_tournament_teams/0 returns all tournament_teams" do
      tournament_team = tournament_team_fixture()
      assert Tournaments.list_tournament_teams() == [tournament_team]
    end

    test "get_tournament_team!/1 returns the tournament_team with given id" do
      tournament_team = tournament_team_fixture()
      assert Tournaments.get_tournament_team!(tournament_team.id) == tournament_team
    end

    test "create_tournament_team/1 with valid data creates a tournament_team" do
      assert {:ok, %TournamentTeam{} = tournament_team} = Tournaments.create_tournament_team(@valid_attrs)
      assert tournament_team.name == "some name"
    end

    test "create_tournament_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_team(@invalid_attrs)
    end

    test "update_tournament_team/2 with valid data updates the tournament_team" do
      tournament_team = tournament_team_fixture()
      assert {:ok, %TournamentTeam{} = tournament_team} = Tournaments.update_tournament_team(tournament_team, @update_attrs)
      assert tournament_team.name == "some updated name"
    end

    test "update_tournament_team/2 with invalid data returns error changeset" do
      tournament_team = tournament_team_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_tournament_team(tournament_team, @invalid_attrs)
      assert tournament_team == Tournaments.get_tournament_team!(tournament_team.id)
    end

    test "delete_tournament_team/1 deletes the tournament_team" do
      tournament_team = tournament_team_fixture()
      assert {:ok, %TournamentTeam{}} = Tournaments.delete_tournament_team(tournament_team)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament_team!(tournament_team.id) end
    end

    test "change_tournament_team/1 returns a tournament_team changeset" do
      tournament_team = tournament_team_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_team(tournament_team)
    end
  end
end
