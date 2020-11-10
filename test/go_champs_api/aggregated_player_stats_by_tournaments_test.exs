defmodule GoChampsApi.AggregatedPlayerStatsByTournamentsTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.AggregatedPlayerStatsByTournaments
  alias GoChampsApi.Tournaments
  alias GoChampsApi.Helpers.OrganizationHelpers
  alias GoChampsApi.PlayerStatsLogs
  alias GoChampsApi.Helpers.PlayerHelpers

  describe "aggregated_player_stats_by_tournament" do
    alias GoChampsApi.Tournaments.Tournament
    alias GoChampsApi.AggregatedPlayerStatsByTournaments.AggregatedPlayerStatsByTournament

    @valid_attrs %{stats: %{"some" => "some"}}
    @update_attrs %{
      stats: %{"some" => "some updated"}
    }
    @invalid_attrs %{player_id: nil, stats: nil, tournament_id: nil}

    @valid_tournament_attrs %{
      name: "some name",
      slug: "some-slug",
      player_stats: [
        %{
          title: "some stat"
        },
        %{
          title: "another stat"
        }
      ]
    }

    def aggregated_player_stats_by_tournament_fixture(attrs \\ %{}) do
      {:ok, aggregated_player_stats_by_tournament} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PlayerHelpers.map_player_id_and_tournament_id()
        |> AggregatedPlayerStatsByTournaments.create_aggregated_player_stats_by_tournament()

      aggregated_player_stats_by_tournament
    end

    test "list_aggregated_player_stats_by_tournament/0 returns all aggregated_player_stats_by_tournament" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament() == [
               aggregated_player_stats_by_tournament
             ]
    end

    test "get_aggregated_player_stats_by_tournament!/1 returns the aggregated_player_stats_by_tournament with given id" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert AggregatedPlayerStatsByTournaments.get_aggregated_player_stats_by_tournament!(
               aggregated_player_stats_by_tournament.id
             ) == aggregated_player_stats_by_tournament
    end

    test "create_aggregated_player_stats_by_tournament/1 with valid data creates a aggregated_player_stats_by_tournament" do
      valid_attrs = PlayerHelpers.map_player_id_and_tournament_id(@valid_attrs)

      assert {:ok, %AggregatedPlayerStatsByTournament{} = aggregated_player_stats_by_tournament} =
               AggregatedPlayerStatsByTournaments.create_aggregated_player_stats_by_tournament(
                 valid_attrs
               )

      assert aggregated_player_stats_by_tournament.player_id != nil
      assert aggregated_player_stats_by_tournament.stats == %{"some" => "some"}
      assert aggregated_player_stats_by_tournament.tournament_id != nil
    end

    test "create_aggregated_player_stats_by_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               AggregatedPlayerStatsByTournaments.create_aggregated_player_stats_by_tournament(
                 @invalid_attrs
               )
    end

    test "update_aggregated_player_stats_by_tournament/2 with valid data updates the aggregated_player_stats_by_tournament" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert {:ok, %AggregatedPlayerStatsByTournament{} = aggregated_player_stats_by_tournament} =
               AggregatedPlayerStatsByTournaments.update_aggregated_player_stats_by_tournament(
                 aggregated_player_stats_by_tournament,
                 @update_attrs
               )

      assert aggregated_player_stats_by_tournament.player_id ==
               aggregated_player_stats_by_tournament.player_id

      assert aggregated_player_stats_by_tournament.stats == %{"some" => "some updated"}

      assert aggregated_player_stats_by_tournament.tournament_id ==
               aggregated_player_stats_by_tournament.tournament_id
    end

    test "update_aggregated_player_stats_by_tournament/2 with invalid data returns error changeset" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert {:error, %Ecto.Changeset{}} =
               AggregatedPlayerStatsByTournaments.update_aggregated_player_stats_by_tournament(
                 aggregated_player_stats_by_tournament,
                 @invalid_attrs
               )

      assert aggregated_player_stats_by_tournament ==
               AggregatedPlayerStatsByTournaments.get_aggregated_player_stats_by_tournament!(
                 aggregated_player_stats_by_tournament.id
               )
    end

    test "delete_aggregated_player_stats_by_tournament/1 deletes the aggregated_player_stats_by_tournament" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert {:ok, %AggregatedPlayerStatsByTournament{}} =
               AggregatedPlayerStatsByTournaments.delete_aggregated_player_stats_by_tournament(
                 aggregated_player_stats_by_tournament
               )

      assert_raise Ecto.NoResultsError, fn ->
        AggregatedPlayerStatsByTournaments.get_aggregated_player_stats_by_tournament!(
          aggregated_player_stats_by_tournament.id
        )
      end
    end

    test "change_aggregated_player_stats_by_tournament/1 returns a aggregated_player_stats_by_tournament changeset" do
      aggregated_player_stats_by_tournament = aggregated_player_stats_by_tournament_fixture()

      assert %Ecto.Changeset{} =
               AggregatedPlayerStatsByTournaments.change_aggregated_player_stats_by_tournament(
                 aggregated_player_stats_by_tournament
               )
    end

    test "generate_aggregated_player_stats_for_tournament/1 inserts aggregated player stats log" do
      valid_tournament = OrganizationHelpers.map_organization_id(@valid_tournament_attrs)
      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(valid_tournament)

      [first_player_stat, second_player_stat] = tournament.player_stats

      first_valid_attrs =
        PlayerHelpers.map_player_id(tournament.id, %{
          stats: %{
            first_player_stat.id => "6",
            second_player_stat.id => "2"
          }
        })

      second_valid_attrs =
        %{
          stats: %{first_player_stat.id => "4", second_player_stat.id => "3"}
        }
        |> Map.merge(%{
          player_id: first_valid_attrs.player_id,
          tournament_id: first_valid_attrs.tournament_id
        })

      assert {:ok, batch_results} =
               PlayerStatsLogs.create_player_stats_logs([first_valid_attrs, second_valid_attrs])

      AggregatedPlayerStatsByTournaments.generate_aggregated_player_stats_for_tournament(
        first_valid_attrs.tournament_id
      )

      [aggregated_player_stats_by_tournament] =
        AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament()

      assert aggregated_player_stats_by_tournament.player_id == first_valid_attrs.player_id

      {:ok, first_stat_value} =
        Map.fetch(aggregated_player_stats_by_tournament.stats, first_player_stat.id)

      assert first_stat_value == 10.0

      {:ok, second_stat_value} =
        Map.fetch(aggregated_player_stats_by_tournament.stats, second_player_stat.id)

      assert second_stat_value == 5

      assert aggregated_player_stats_by_tournament.tournament_id ==
               first_valid_attrs.tournament_id
    end
  end
end