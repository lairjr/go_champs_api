defmodule GoChampsApi.Helpers.TeamHelpers do
  alias GoChampsApi.Helpers.TournamentHelpers
  alias GoChampsApi.Teams

  def map_team_id(tournament_id, attrs \\ %{}) do
    {:ok, team} =
      %{name: "some team", tournament_id: tournament_id}
      |> Teams.create_team()

    Map.merge(attrs, %{team_id: team.id, tournament_id: team.tournament_id})
  end

  def map_team_id_and_tournament_id(attrs \\ %{}) do
    {:ok, team} =
      %{name: "some team"}
      |> TournamentHelpers.map_tournament_id()
      |> Teams.create_team()

    Map.merge(attrs, %{team_id: team.id, tournament_id: team.tournament_id})
  end

  def map_team_id_and_tournament_id_with_other_member(attrs \\ %{}) do
    {:ok, team} =
      %{name: "some team"}
      |> TournamentHelpers.map_tournament_id_with_other_member()
      |> Teams.create_team()

    Map.merge(attrs, %{team_id: team.id, tournament_id: team.tournament_id})
  end
end
