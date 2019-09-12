defmodule TournamentsApi.TournamentsTest do
  use TournamentsApi.DataCase

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

    def map_tournament_id(attrs \\ %{}) do
      tournament = tournament_fixture(%{name: "some tournament name"})
      Map.merge(attrs, %{tournament_id: tournament.id})
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

    def map_tournament_phase_id(attrs \\ %{}) do
      tournament_phase_attrs = map_tournament_id(%{title: "tournament phase", type: "standings"})

      {:ok, tournament_phase} =
        tournament_phase_attrs
        |> Tournaments.create_tournament_phase()

      Map.merge(attrs, %{tournament_phase_id: tournament_phase.id})
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

  describe "tournament_groups" do
    alias TournamentsApi.Tournaments.Tournament
    alias TournamentsApi.Tournaments.TournamentGroup

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tournament_group_fixture(attrs \\ %{}) do
      {:ok, tournament_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_tournament_phase_id()
        |> Tournaments.create_tournament_group()

      tournament_group
    end

    test "list_tournament_groups/0 returns all tournament_groups" do
      tournament_group = tournament_group_fixture()

      [result_group] = Tournaments.list_tournament_groups(tournament_group.tournament_phase_id)
      assert result_group.id == tournament_group.id
    end

    test "get_tournament_group!/1 returns the tournament_group with given id" do
      tournament_group = tournament_group_fixture()

      assert Tournaments.get_tournament_group!(
               tournament_group.id,
               tournament_group.tournament_phase_id
             ) == tournament_group
    end

    test "create_tournament_group/1 with valid data creates a tournament_group" do
      attrs = map_tournament_phase_id(@valid_attrs)

      assert {:ok, %TournamentGroup{} = tournament_group} =
               Tournaments.create_tournament_group(attrs)

      assert tournament_group.name == "some name"
    end

    test "create_tournament_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_group(@invalid_attrs)
    end

    test "update_tournament_group/2 with valid data updates the tournament_group" do
      tournament_group = tournament_group_fixture()

      assert {:ok, %TournamentGroup{} = tournament_group} =
               Tournaments.update_tournament_group(tournament_group, @update_attrs)

      assert tournament_group.name == "some updated name"
    end

    test "update_tournament_group/2 with invalid data returns error changeset" do
      tournament_group = tournament_group_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_group(tournament_group, @invalid_attrs)

      result_group =
        Tournaments.get_tournament_group!(
          tournament_group.id,
          tournament_group.tournament_phase_id
        )

      assert result_group.id == tournament_group.id
    end

    test "delete_tournament_group/1 deletes the tournament_group" do
      tournament_group = tournament_group_fixture()
      assert {:ok, %TournamentGroup{}} = Tournaments.delete_tournament_group(tournament_group)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_group!(
          tournament_group.id,
          tournament_group.tournament_phase_id
        )
      end
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
        |> map_tournament_id()
        |> Tournaments.create_tournament_team()

      tournament_team
    end

    test "list_tournament_teams/0 returns all tournament_teams" do
      tournament_team = tournament_team_fixture()
      [result_team] = Tournaments.list_tournament_teams(tournament_team.tournament_id)
      assert result_team.id == tournament_team.id
    end

    test "get_tournament_team!/1 returns the tournament_team with given id" do
      tournament_team = tournament_team_fixture()

      result_team =
        Tournaments.get_tournament_team!(tournament_team.id, tournament_team.tournament_id)

      assert result_team.id == tournament_team.id
    end

    test "create_tournament_team/1 with valid data creates a tournament_team" do
      attrs =
        tournament_team_fixture()
        |> Map.from_struct()

      assert {:ok, %TournamentTeam{} = tournament_team} =
               Tournaments.create_tournament_team(attrs)

      assert tournament_team.name == "some name"
    end

    test "create_tournament_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_team(@invalid_attrs)
    end

    test "update_tournament_team/2 with valid data updates the tournament_team" do
      tournament_team = tournament_team_fixture()
      attrs = Map.merge(@update_attrs, %{tournament_id: tournament_team.tournament_id})

      assert {:ok, %TournamentTeam{} = tournament_team} =
               Tournaments.update_tournament_team(tournament_team, attrs)

      assert tournament_team.name == "some updated name"
    end

    test "update_tournament_team/2 with invalid data returns error changeset" do
      tournament_team = tournament_team_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_team(tournament_team, @invalid_attrs)

      result_team =
        Tournaments.get_tournament_team!(tournament_team.id, tournament_team.tournament_id)

      assert result_team.id == tournament_team.id
    end

    test "delete_tournament_team/1 deletes the tournament_team" do
      tournament_team = tournament_team_fixture()
      assert {:ok, %TournamentTeam{}} = Tournaments.delete_tournament_team(tournament_team)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_team!(tournament_team.id, tournament_team.tournament_id)
      end
    end

    test "change_tournament_team/1 returns a tournament_team changeset" do
      tournament_team = tournament_team_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_team(tournament_team)
    end
  end

  describe "tournament_games" do
    alias TournamentsApi.Tournaments.TournamentGame

    @valid_attrs %{
      away_score: 10,
      datetime: "2019-08-25T16:59:27.116Z",
      home_score: 20,
      location: "some location"
    }
    @update_attrs %{
      away_score: 20,
      datetime: "2019-08-25T16:59:27.116Z",
      home_score: 30,
      location: "another location"
    }
    @invalid_attrs %{tournament_phase_id: nil}

    def tournament_game_fixture(attrs \\ %{}) do
      {:ok, tournament_game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_tournament_phase_id()
        |> Tournaments.create_tournament_game()

      tournament_game
    end

    test "list_tournament_games/0 returns all tournament_games" do
      tournament_game = tournament_game_fixture()
      [result_game] = Tournaments.list_tournament_games(tournament_game.tournament_phase_id)
      assert result_game.id == tournament_game.id
    end

    test "get_tournament_game!/1 returns the tournament_game with given id" do
      tournament_game = tournament_game_fixture()

      result_game =
        Tournaments.get_tournament_game!(tournament_game.id, tournament_game.tournament_phase_id)

      assert result_game.id == tournament_game.id
    end

    test "create_tournament_game/1 with valid data creates a tournament_game" do
      valid_tournament =
        tournament_game_fixture()
        |> Map.from_struct()

      assert {:ok, %TournamentGame{} = tournament_game} =
               Tournaments.create_tournament_game(valid_tournament)
    end

    test "create_tournament_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_game(@invalid_attrs)
    end

    test "update_tournament_game/2 with valid data updates the tournament_game" do
      tournament_game = tournament_game_fixture()

      attrs =
        Map.merge(@update_attrs, %{tournament_phase_id: tournament_game.tournament_phase_id})

      {:ok, %TournamentGame{} = updated_tournament_game} =
        Tournaments.update_tournament_game(tournament_game, attrs)

      assert updated_tournament_game.away_score == attrs.away_score
      assert updated_tournament_game.home_score == attrs.home_score
      assert updated_tournament_game.location == attrs.location
    end

    test "update_tournament_game/2 with invalid data returns error changeset" do
      tournament_game = tournament_game_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_game(tournament_game, @invalid_attrs)

      result_game =
        Tournaments.get_tournament_game!(tournament_game.id, tournament_game.tournament_phase_id)

      assert result_game.id == tournament_game.id
    end

    test "delete_tournament_game/1 deletes the tournament_game" do
      tournament_game = tournament_game_fixture()
      assert {:ok, %TournamentGame{}} = Tournaments.delete_tournament_game(tournament_game)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_game!(tournament_game.id, tournament_game.tournament_phase_id)
      end
    end

    test "change_tournament_game/1 returns a tournament_game changeset" do
      tournament_game = tournament_game_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_game(tournament_game)
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
        |> map_tournament_phase_id()
        |> Tournaments.create_tournament_stat()

      tournament_stat
    end

    test "list_tournament_stats/0 returns all tournament_stats" do
      random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      tournament_stat = tournament_stat_fixture()

      [result_stat] = Tournaments.list_tournament_stats(tournament_stat.tournament_phase_id)
      assert result_stat.id == tournament_stat.id
      assert Tournaments.list_tournament_stats(random_uuid) == []
    end

    test "get_tournament_stat!/1 returns the tournament_stat with given id" do
      tournament_stat = tournament_stat_fixture()

      result_stat =
        Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.tournament_phase_id)

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

      attrs =
        Map.merge(@update_attrs, %{tournament_phase_id: tournament_stat.tournament_phase_id})

      assert {:ok, %TournamentStat{} = tournament_stat} =
               Tournaments.update_tournament_stat(tournament_stat, attrs)

      assert tournament_stat.title == "some updated title"
    end

    test "update_tournament_stat/2 with invalid data returns error changeset" do
      tournament_stat = tournament_stat_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_stat(tournament_stat, @invalid_attrs)

      result_stat =
        Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.tournament_phase_id)

      assert result_stat.id == tournament_stat.id
    end

    test "delete_tournament_stat/1 deletes the tournament_stat" do
      tournament_stat = tournament_stat_fixture()
      assert {:ok, %TournamentStat{}} = Tournaments.delete_tournament_stat(tournament_stat)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_stat!(tournament_stat.id, tournament_stat.tournament_phase_id)
      end
    end

    test "change_tournament_stat/1 returns a tournament_stat changeset" do
      tournament_stat = tournament_stat_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_stat(tournament_stat)
    end
  end

  describe "tournament_phases" do
    alias TournamentsApi.Tournaments.TournamentPhase

    @valid_attrs %{title: "some title", type: "standings"}
    @update_attrs %{title: "some updated title", type: "standings"}
    @invalid_attrs %{title: nil, type: nil}

    def tournament_phase_fixture(attrs \\ %{}) do
      {:ok, tournament_phase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_tournament_id()
        |> Tournaments.create_tournament_phase()

      tournament_phase
    end

    test "list_tournament_phases/0 returns all tournament_phases" do
      random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      tournament_phase = tournament_phase_fixture()

      assert Tournaments.list_tournament_phases(tournament_phase.tournament_id) == [
               tournament_phase
             ]

      assert Tournaments.list_tournament_phases(random_uuid) == []
    end

    test "get_tournament_phase!/1 returns the tournament_phase with given id" do
      tournament_phase = tournament_phase_fixture()

      assert Tournaments.get_tournament_phase!(
               tournament_phase.id,
               tournament_phase.tournament_id
             ).id == tournament_phase.id
    end

    test "create_tournament_phase/1 with valid data creates a tournament_phase" do
      attrs = map_tournament_id(@valid_attrs)

      assert {:ok, %TournamentPhase{} = tournament_phase} =
               Tournaments.create_tournament_phase(attrs)

      assert tournament_phase.title == "some title"
      assert tournament_phase.type == "standings"
      assert tournament_phase.order == 1
    end

    test "create_tournament_phase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_phase(@invalid_attrs)
    end

    test "create_tournament_phase/1 select order for second item" do
      attrs = map_tournament_id(@valid_attrs)

      assert {:ok, %TournamentPhase{} = first_tournament_phase} =
               Tournaments.create_tournament_phase(attrs)

      assert {:ok, %TournamentPhase{} = second_tournament_phase} =
               Tournaments.create_tournament_phase(attrs)

      assert first_tournament_phase.order == 1
      assert second_tournament_phase.order == 2
    end

    test "create_tournament_phase/1 set order as 1 for new tournament_phase" do
      first_attrs = map_tournament_id(@valid_attrs)

      assert {:ok, %TournamentPhase{} = first_tournament_phase} =
               Tournaments.create_tournament_phase(first_attrs)

      [organization] = Organizations.list_organizations()

      {:ok, second_tournament} =
        Tournaments.create_tournament(%{
          name: "some other tournament name",
          organization_id: organization.id
        })

      second_attrs = Map.merge(@valid_attrs, %{tournament_id: second_tournament.id})

      assert {:ok, %TournamentPhase{} = second_tournament_phase} =
               Tournaments.create_tournament_phase(second_attrs)

      assert first_tournament_phase.order == 1
      assert second_tournament_phase.order == 2
    end

    test "update_tournament_phase/2 with valid data updates the tournament_phase" do
      tournament_phase = tournament_phase_fixture()

      assert {:ok, %TournamentPhase{} = tournament_phase} =
               Tournaments.update_tournament_phase(tournament_phase, @update_attrs)

      assert tournament_phase.title == "some updated title"
      assert tournament_phase.type == "standings"
    end

    test "update_tournament_phase/2 with invalid data returns error changeset" do
      tournament_phase = tournament_phase_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_phase(tournament_phase, @invalid_attrs)

      result_phase =
        Tournaments.get_tournament_phase!(tournament_phase.id, tournament_phase.tournament_id)

      assert tournament_phase.id == result_phase.id
    end

    test "delete_tournament_phase/1 deletes the tournament_phase" do
      tournament_phase = tournament_phase_fixture()
      assert {:ok, %TournamentPhase{}} = Tournaments.delete_tournament_phase(tournament_phase)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_phase!(tournament_phase.id, tournament_phase.tournament_id)
      end
    end

    test "change_tournament_phase/1 returns a tournament_phase changeset" do
      tournament_phase = tournament_phase_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_phase(tournament_phase)
    end
  end
end
