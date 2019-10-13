defmodule TournamentsApi.PhasesTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Helpers.TournamentHelpers
  alias TournamentsApi.Organizations
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Phases

  describe "phases" do
    alias TournamentsApi.Phases.Phase

    @valid_attrs %{title: "some title", type: "standings"}
    @update_attrs %{title: "some updated title", type: "standings"}
    @invalid_attrs %{title: nil, type: nil}

    def phase_fixture(attrs \\ %{}) do
      {:ok, phase} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TournamentHelpers.map_tournament_id()
        |> Phases.create_phase()

      phase
    end

    test "get_phase!/1 returns the phase with given id" do
      phase = phase_fixture()

      assert Phases.get_phase!(phase.id).id == phase.id
    end

    test "create_phase/1 with valid data creates a phase" do
      attrs = TournamentHelpers.map_tournament_id(@valid_attrs)

      assert {:ok, %Phase{} = phase} = Phases.create_phase(attrs)

      assert phase.title == "some title"
      assert phase.type == "standings"
      assert phase.order == 1
    end

    test "create_phase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Phases.create_phase(@invalid_attrs)
    end

    test "create_phase/1 select order for second item" do
      attrs = TournamentHelpers.map_tournament_id(@valid_attrs)

      assert {:ok, %Phase{} = first_phase} = Phases.create_phase(attrs)

      assert {:ok, %Phase{} = second_phase} = Phases.create_phase(attrs)

      assert first_phase.order == 1
      assert second_phase.order == 2
    end

    test "create_phase/1 set order as 1 for new phase" do
      first_attrs = TournamentHelpers.map_tournament_id(@valid_attrs)

      assert {:ok, %Phase{} = first_phase} = Phases.create_phase(first_attrs)

      [organization] = Organizations.list_organizations()

      {:ok, second_tournament} =
        Tournaments.create_tournament(%{
          name: "some other tournament name",
          organization_id: organization.id
        })

      second_attrs = Map.merge(@valid_attrs, %{tournament_id: second_tournament.id})

      assert {:ok, %Phase{} = second_phase} = Phases.create_phase(second_attrs)

      assert first_phase.order == 1
      assert second_phase.order == 2
    end

    test "update_phase/2 with valid data updates the phase" do
      phase = phase_fixture()

      assert {:ok, %Phase{} = phase} = Phases.update_phase(phase, @update_attrs)

      assert phase.title == "some updated title"
      assert phase.type == "standings"
    end

    test "update_phase/2 with invalid data returns error changeset" do
      phase = phase_fixture()

      assert {:error, %Ecto.Changeset{}} = Phases.update_phase(phase, @invalid_attrs)

      result_phase = Phases.get_phase!(phase.id)

      assert phase.id == result_phase.id
    end

    test "delete_phase/1 deletes the phase" do
      phase = phase_fixture()
      assert {:ok, %Phase{}} = Phases.delete_phase(phase)

      assert_raise Ecto.NoResultsError, fn ->
        Phases.get_phase!(phase.id)
      end
    end

    test "change_phase/1 returns a phase changeset" do
      phase = phase_fixture()
      assert %Ecto.Changeset{} = Phases.change_phase(phase)
    end
  end

  describe "phase_rounds" do
    alias TournamentsApi.Phases.PhaseRound

    @valid_attrs %{
      title: "some title",
      matches: [
        %{
          first_team_placeholder: "some-first-team-placeholder",
          second_team_placeholder: "some-second-team-placeholder"
        }
      ]
    }
    @update_attrs %{
      title: "some updated title",
      matches: [
        %{
          first_team_placeholder: "some-updated-first-team-placeholder",
          second_team_placeholder: "some-updated-second-team-placeholder"
        }
      ]
    }
    @invalid_attrs %{title: nil, matches: nil}

    def phase_round_fixture(attrs \\ %{}) do
      {:ok, phase_round} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PhaseHelpers.map_phase_id()
        |> Phases.create_phase_round()

      phase_round
    end

    test "list_phase_rounds/0 returns all phase_rounds" do
      phase_round = phase_round_fixture()
      assert Phases.list_phase_rounds(phase_round.phase_id) == [phase_round]
    end

    test "get_phase_round!/1 returns the phase_round with given id" do
      phase_round = phase_round_fixture()

      assert Phases.get_phase_round!(phase_round.id, phase_round.phase_id) ==
               phase_round
    end

    test "create_phase_round/1 with valid data creates a phase_round" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)
      assert {:ok, %PhaseRound{} = phase_round} = Phases.create_phase_round(attrs)

      [match] = phase_round.matches
      assert phase_round.order == 1
      assert phase_round.title == "some title"
      assert match.first_team_placeholder == "some-first-team-placeholder"
      assert match.second_team_placeholder == "some-second-team-placeholder"
    end

    test "create_phase_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Phases.create_phase_round(@invalid_attrs)
    end

    test "create_phase_round/1 select order for second item" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)

      assert {:ok, %PhaseRound{} = first_phase_round} = Phases.create_phase_round(attrs)

      assert {:ok, %PhaseRound{} = second_phase_round} = Phases.create_phase_round(attrs)

      assert first_phase_round.order == 1
      assert second_phase_round.order == 2
    end

    test "update_phase_round/2 with valid data updates the phase_round" do
      phase_round = phase_round_fixture()

      assert {:ok, %PhaseRound{} = phase_round} =
               Phases.update_phase_round(phase_round, @update_attrs)

      [match] = phase_round.matches
      assert phase_round.title == "some updated title"
      assert match.first_team_placeholder == "some-updated-first-team-placeholder"
      assert match.second_team_placeholder == "some-updated-second-team-placeholder"
    end

    test "update_phase_round/2 with invalid data returns error changeset" do
      phase_round = phase_round_fixture()
      assert {:error, %Ecto.Changeset{}} = Phases.update_phase_round(phase_round, @invalid_attrs)

      assert phase_round ==
               Phases.get_phase_round!(phase_round.id, phase_round.phase_id)
    end

    test "delete_phase_round/1 deletes the phase_round" do
      phase_round = phase_round_fixture()
      assert {:ok, %PhaseRound{}} = Phases.delete_phase_round(phase_round)

      assert_raise Ecto.NoResultsError, fn ->
        Phases.get_phase_round!(phase_round.id, phase_round.phase_id)
      end
    end

    test "change_phase_round/1 returns a phase_round changeset" do
      phase_round = phase_round_fixture()
      assert %Ecto.Changeset{} = Phases.change_phase_round(phase_round)
    end
  end
end
