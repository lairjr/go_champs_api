defmodule TournamentsApi.Helpers.TournamentHelpers do
  alias TournamentsApi.Helpers.OrganizationHelpers
  alias TournamentsApi.Tournaments

  def map_tournament_id(attrs \\ %{}) do
    {:ok, tournament} =
      %{name: "some tournament"}
      |> OrganizationHelpers.map_organization_id()
      |> Tournaments.create_tournament()

    Map.merge(attrs, %{tournament_id: tournament.id})
  end
end
