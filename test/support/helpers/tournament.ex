defmodule GoChampsApi.Helpers.TournamentHelpers do
  alias GoChampsApi.Helpers.OrganizationHelpers
  alias GoChampsApi.Tournaments

  def map_tournament_id(attrs \\ %{}) do
    {:ok, tournament} =
      %{name: "some tournament", slug: "some-slug"}
      |> OrganizationHelpers.map_organization_id()
      |> Tournaments.create_tournament()

    Map.merge(attrs, %{tournament_id: tournament.id})
  end

  def map_tournament_id_with_other_member(attrs \\ %{}) do
    {:ok, tournament} =
      %{name: "some tournament", slug: "some-slug"}
      |> OrganizationHelpers.map_organization_id_with_other_member()
      |> Tournaments.create_tournament()

    Map.merge(attrs, %{tournament_id: tournament.id})
  end

  def map_tournament_id_and_stat_id(attrs \\ %{}) do
    {:ok, tournament} =
      %{
        name: "some tournament",
        slug: "some-slug",
        player_stats: [
          %{
            title: "some stat"
          }
        ]
      }
      |> OrganizationHelpers.map_organization_id()
      |> Tournaments.create_tournament()

    [player_stat] = tournament.player_stats

    Map.merge(attrs, %{tournament_id: tournament.id, stat_id: player_stat.id})
  end

  def map_tournament_id_and_stat_id_with_other_member(attrs \\ %{}) do
    {:ok, tournament} =
      %{
        name: "some tournament",
        slug: "some-slug",
        player_stats: [
          %{
            title: "some stat"
          }
        ]
      }
      |> OrganizationHelpers.map_organization_id_with_other_member()
      |> Tournaments.create_tournament()

    [player_stat] = tournament.player_stats

    Map.merge(attrs, %{tournament_id: tournament.id, stat_id: player_stat.id})
  end
end
