defmodule GoChampsApi.PendingAggregatedTeamStatsByPhasesTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.Helpers.PhaseHelpers
  alias GoChampsApi.PendingAggregatedTeamStatsByPhases

  describe "pending_aggregated_team_stats_by_phase" do
    alias GoChampsApi.PendingAggregatedTeamStatsByPhases.PendingAggregatedTeamStatsByPhase

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{tournament_id: nil}

    def pending_aggregated_team_stats_by_phase_fixture(attrs \\ %{}) do
      {:ok, pending_aggregated_team_stats_by_phase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PhaseHelpers.map_phase_id_and_tournament_id()
        |> PendingAggregatedTeamStatsByPhases.create_pending_aggregated_team_stats_by_phase()

      pending_aggregated_team_stats_by_phase
    end

    test "list_pending_aggregated_team_stats_by_phase/0 returns all pending_aggregated_team_stats_by_phase" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert PendingAggregatedTeamStatsByPhases.list_pending_aggregated_team_stats_by_phase() == [
               pending_aggregated_team_stats_by_phase
             ]
    end

    test "get_pending_aggregated_team_stats_by_phase!/1 returns the pending_aggregated_team_stats_by_phase with given id" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert PendingAggregatedTeamStatsByPhases.get_pending_aggregated_team_stats_by_phase!(
               pending_aggregated_team_stats_by_phase.id
             ) == pending_aggregated_team_stats_by_phase
    end

    test "create_pending_aggregated_team_stats_by_phase/1 with valid data creates a pending_aggregated_team_stats_by_phase" do
      attrs =
        @valid_attrs
        |> PhaseHelpers.map_phase_id_and_tournament_id()

      assert {:ok, %PendingAggregatedTeamStatsByPhase{} = pending_aggregated_team_stats_by_phase} =
               PendingAggregatedTeamStatsByPhases.create_pending_aggregated_team_stats_by_phase(
                 attrs
               )

      assert pending_aggregated_team_stats_by_phase.phase_id != nil
      assert pending_aggregated_team_stats_by_phase.tournament_id != nil
    end

    test "create_pending_aggregated_team_stats_by_phase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               PendingAggregatedTeamStatsByPhases.create_pending_aggregated_team_stats_by_phase(
                 @invalid_attrs
               )
    end

    test "update_pending_aggregated_team_stats_by_phase/2 with valid data updates the pending_aggregated_team_stats_by_phase" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert {:ok, %PendingAggregatedTeamStatsByPhase{} = pending_aggregated_team_stats_by_phase} =
               PendingAggregatedTeamStatsByPhases.update_pending_aggregated_team_stats_by_phase(
                 pending_aggregated_team_stats_by_phase,
                 @update_attrs
               )

      assert pending_aggregated_team_stats_by_phase.phase_id != nil
      assert pending_aggregated_team_stats_by_phase.tournament_id != nil
    end

    test "update_pending_aggregated_team_stats_by_phase/2 with invalid data returns error changeset" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PendingAggregatedTeamStatsByPhases.update_pending_aggregated_team_stats_by_phase(
                 pending_aggregated_team_stats_by_phase,
                 @invalid_attrs
               )

      assert pending_aggregated_team_stats_by_phase ==
               PendingAggregatedTeamStatsByPhases.get_pending_aggregated_team_stats_by_phase!(
                 pending_aggregated_team_stats_by_phase.id
               )
    end

    test "delete_pending_aggregated_team_stats_by_phase/1 deletes the pending_aggregated_team_stats_by_phase" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert {:ok, %PendingAggregatedTeamStatsByPhase{}} =
               PendingAggregatedTeamStatsByPhases.delete_pending_aggregated_team_stats_by_phase(
                 pending_aggregated_team_stats_by_phase
               )

      assert_raise Ecto.NoResultsError, fn ->
        PendingAggregatedTeamStatsByPhases.get_pending_aggregated_team_stats_by_phase!(
          pending_aggregated_team_stats_by_phase.id
        )
      end
    end

    test "change_pending_aggregated_team_stats_by_phase/1 returns a pending_aggregated_team_stats_by_phase changeset" do
      pending_aggregated_team_stats_by_phase = pending_aggregated_team_stats_by_phase_fixture()

      assert %Ecto.Changeset{} =
               PendingAggregatedTeamStatsByPhases.change_pending_aggregated_team_stats_by_phase(
                 pending_aggregated_team_stats_by_phase
               )
    end
  end
end
