defmodule TournamentsApi.PhasesTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Organizations
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Phases

  describe "phase_standings" do
    alias TournamentsApi.Phases.PhaseStandings

    random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
    @valid_attrs %{standings: [%{team_id: random_uuid, stats: %{"key" => "value"}}]}
    @update_attrs %{standings: [%{team_id: random_uuid, stats: %{"key" => "updated"}}]}
    @invalid_attrs %{standings: nil}

    def map_tournament_phase_id(attrs \\ %{}) do
      {:ok, organization} =
        Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

      tournament_attrs =
        Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})

      {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)

      tournament_phase_attrs =
        Map.merge(%{title: "some phase", type: "stadings"}, %{tournament_id: tournament.id})

      {:ok, tournament_phase} = Tournaments.create_tournament_phase(tournament_phase_attrs)

      Map.merge(attrs, %{tournament_phase_id: tournament_phase.id})
    end

    def phase_standings_fixture(attrs \\ %{}) do
      {:ok, phase_standings} =
        attrs
        |> Enum.into(@valid_attrs)
        |> map_tournament_phase_id()
        |> Phases.create_phase_standings()

      phase_standings
    end

    test "list_phase_standings/0 returns all phase_standings" do
      phase_standings = phase_standings_fixture()
      assert Phases.list_phase_standings(phase_standings.tournament_phase_id) == [phase_standings]
    end

    test "get_phase_standings!/1 returns the phase_standings with given id" do
      phase_standings = phase_standings_fixture()

      assert Phases.get_phase_standings!(phase_standings.id, phase_standings.tournament_phase_id) ==
               phase_standings
    end

    test "create_phase_standings/1 with valid data creates a phase_standings" do
      attrs = map_tournament_phase_id(@valid_attrs)
      assert {:ok, %PhaseStandings{} = phase_standings} = Phases.create_phase_standings(attrs)

      [standings] = phase_standings.standings
      assert standings.team_id == "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      assert standings.stats == %{"key" => "value"}
    end

    test "create_phase_standings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Phases.create_phase_standings(@invalid_attrs)
    end

    test "update_phase_standings/2 with valid data updates the phase_standings" do
      phase_standings = phase_standings_fixture()

      assert {:ok, %PhaseStandings{} = phase_standings} =
               Phases.update_phase_standings(phase_standings, @update_attrs)

      [standings] = phase_standings.standings
      assert standings.team_id == "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      assert standings.stats == %{"key" => "updated"}
    end

    test "update_phase_standings/2 with invalid data returns error changeset" do
      phase_standings = phase_standings_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Phases.update_phase_standings(phase_standings, @invalid_attrs)

      assert phase_standings ==
               Phases.get_phase_standings!(
                 phase_standings.id,
                 phase_standings.tournament_phase_id
               )
    end

    test "delete_phase_standings/1 deletes the phase_standings" do
      phase_standings = phase_standings_fixture()
      assert {:ok, %PhaseStandings{}} = Phases.delete_phase_standings(phase_standings)

      assert_raise Ecto.NoResultsError, fn ->
        Phases.get_phase_standings!(phase_standings.id, phase_standings.tournament_phase_id)
      end
    end

    test "change_phase_standings/1 returns a phase_standings changeset" do
      phase_standings = phase_standings_fixture()
      assert %Ecto.Changeset{} = Phases.change_phase_standings(phase_standings)
    end
  end
end
