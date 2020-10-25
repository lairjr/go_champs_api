defmodule GoChampsApi.AggregatedPlayerStatsByTournaments do
  @moduledoc """
  The AggregatedPlayerStatsByTournaments context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.AggregatedPlayerStatsByTournaments.AggregatedPlayerStatsByTournament

  @doc """
  Returns the list of aggregated_player_stats_by_tournament.

  ## Examples

      iex> list_aggregated_player_stats_by_tournament()
      [%AggregatedPlayerStatsByTournament{}, ...]

  """
  def list_aggregated_player_stats_by_tournament do
    Repo.all(AggregatedPlayerStatsByTournament)
  end

  @doc """
  Gets a single aggregated_player_stats_by_tournament.

  Raises `Ecto.NoResultsError` if the Aggregated player stats by tournament does not exist.

  ## Examples

      iex> get_aggregated_player_stats_by_tournament!(123)
      %AggregatedPlayerStatsByTournament{}

      iex> get_aggregated_player_stats_by_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_aggregated_player_stats_by_tournament!(id),
    do: Repo.get!(AggregatedPlayerStatsByTournament, id)

  @doc """
  Creates a aggregated_player_stats_by_tournament.

  ## Examples

      iex> create_aggregated_player_stats_by_tournament(%{field: value})
      {:ok, %AggregatedPlayerStatsByTournament{}}

      iex> create_aggregated_player_stats_by_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_aggregated_player_stats_by_tournament(attrs \\ %{}) do
    %AggregatedPlayerStatsByTournament{}
    |> AggregatedPlayerStatsByTournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a aggregated_player_stats_by_tournament.

  ## Examples

      iex> update_aggregated_player_stats_by_tournament(aggregated_player_stats_by_tournament, %{field: new_value})
      {:ok, %AggregatedPlayerStatsByTournament{}}

      iex> update_aggregated_player_stats_by_tournament(aggregated_player_stats_by_tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_aggregated_player_stats_by_tournament(
        %AggregatedPlayerStatsByTournament{} = aggregated_player_stats_by_tournament,
        attrs
      ) do
    aggregated_player_stats_by_tournament
    |> AggregatedPlayerStatsByTournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a aggregated_player_stats_by_tournament.

  ## Examples

      iex> delete_aggregated_player_stats_by_tournament(aggregated_player_stats_by_tournament)
      {:ok, %AggregatedPlayerStatsByTournament{}}

      iex> delete_aggregated_player_stats_by_tournament(aggregated_player_stats_by_tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_aggregated_player_stats_by_tournament(
        %AggregatedPlayerStatsByTournament{} = aggregated_player_stats_by_tournament
      ) do
    Repo.delete(aggregated_player_stats_by_tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking aggregated_player_stats_by_tournament changes.

  ## Examples

      iex> change_aggregated_player_stats_by_tournament(aggregated_player_stats_by_tournament)
      %Ecto.Changeset{source: %AggregatedPlayerStatsByTournament{}}

  """
  def change_aggregated_player_stats_by_tournament(
        %AggregatedPlayerStatsByTournament{} = aggregated_player_stats_by_tournament
      ) do
    AggregatedPlayerStatsByTournament.changeset(aggregated_player_stats_by_tournament, %{})
  end
end
