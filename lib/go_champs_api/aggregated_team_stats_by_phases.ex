defmodule GoChampsApi.AggregatedTeamStatsByPhases do
  @moduledoc """
  The AggregatedTeamStatsByPhases context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.AggregatedTeamStatsByPhases.AggregatedTeamStatsByPhase

  @doc """
  Returns the list of aggregated_team_stats_by_phase.

  ## Examples

      iex> list_aggregated_team_stats_by_phase()
      [%AggregatedTeamStatsByPhase{}, ...]

  """
  def list_aggregated_team_stats_by_phase do
    Repo.all(AggregatedTeamStatsByPhase)
  end

  @doc """
  Gets a single aggregated_team_stats_by_phase.

  Raises `Ecto.NoResultsError` if the Aggregated team stats by phase does not exist.

  ## Examples

      iex> get_aggregated_team_stats_by_phase!(123)
      %AggregatedTeamStatsByPhase{}

      iex> get_aggregated_team_stats_by_phase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_aggregated_team_stats_by_phase!(id), do: Repo.get!(AggregatedTeamStatsByPhase, id)

  @doc """
  Creates a aggregated_team_stats_by_phase.

  ## Examples

      iex> create_aggregated_team_stats_by_phase(%{field: value})
      {:ok, %AggregatedTeamStatsByPhase{}}

      iex> create_aggregated_team_stats_by_phase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_aggregated_team_stats_by_phase(attrs \\ %{}) do
    %AggregatedTeamStatsByPhase{}
    |> AggregatedTeamStatsByPhase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a aggregated_team_stats_by_phase.

  ## Examples

      iex> update_aggregated_team_stats_by_phase(aggregated_team_stats_by_phase, %{field: new_value})
      {:ok, %AggregatedTeamStatsByPhase{}}

      iex> update_aggregated_team_stats_by_phase(aggregated_team_stats_by_phase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_aggregated_team_stats_by_phase(
        %AggregatedTeamStatsByPhase{} = aggregated_team_stats_by_phase,
        attrs
      ) do
    aggregated_team_stats_by_phase
    |> AggregatedTeamStatsByPhase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a aggregated_team_stats_by_phase.

  ## Examples

      iex> delete_aggregated_team_stats_by_phase(aggregated_team_stats_by_phase)
      {:ok, %AggregatedTeamStatsByPhase{}}

      iex> delete_aggregated_team_stats_by_phase(aggregated_team_stats_by_phase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_aggregated_team_stats_by_phase(
        %AggregatedTeamStatsByPhase{} = aggregated_team_stats_by_phase
      ) do
    Repo.delete(aggregated_team_stats_by_phase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking aggregated_team_stats_by_phase changes.

  ## Examples

      iex> change_aggregated_team_stats_by_phase(aggregated_team_stats_by_phase)
      %Ecto.Changeset{data: %AggregatedTeamStatsByPhase{}}

  """
  def change_aggregated_team_stats_by_phase(
        %AggregatedTeamStatsByPhase{} = aggregated_team_stats_by_phase,
        attrs \\ %{}
      ) do
    AggregatedTeamStatsByPhase.changeset(aggregated_team_stats_by_phase, attrs)
  end
end
