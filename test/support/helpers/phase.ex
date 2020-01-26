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
end
