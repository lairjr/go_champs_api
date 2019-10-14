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
end
