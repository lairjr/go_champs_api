defmodule GoChampsApi.Helpers.PhaseHelpers do
  alias GoChampsApi.Helpers.TournamentHelpers
  alias GoChampsApi.Phases

  def map_phase_id(attrs \\ %{}) do
    {:ok, phase} =
      %{title: "some phase", type: "stadings"}
      |> TournamentHelpers.map_tournament_id()
      |> Phases.create_phase()

    Map.merge(attrs, %{phase_id: phase.id})
  end

  def map_phase_id_and_tournament_id(attrs \\ %{}) do
    {:ok, phase} =
      %{title: "some phase", type: "stadings"}
      |> TournamentHelpers.map_tournament_id()
      |> Phases.create_phase()

    Map.merge(attrs, %{phase_id: phase.id, tournament_id: phase.tournament_id})
  end

  @spec map_phase_id_for_tournament(%{:tournament_id => any, optional(any) => any}) :: %{
          :phase_id => any,
          :tournament_id => any,
          optional(any) => any
        }
  def map_phase_id_for_tournament(attrs \\ %{tournament_id: ''}) do
    {:ok, phase} =
      %{title: "some phase", type: "stadings", tournament_id: attrs.tournament_id}
      |> Phases.create_phase()

    Map.merge(attrs, %{phase_id: phase.id})
  end

  def map_phase_id_with_other_member(attrs \\ %{}) do
    {:ok, phase} =
      %{title: "some phase", type: "stadings"}
      |> TournamentHelpers.map_tournament_id_with_other_member()
      |> Phases.create_phase()

    Map.merge(attrs, %{phase_id: phase.id})
  end
end
