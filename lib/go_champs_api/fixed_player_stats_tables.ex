defmodule GoChampsApi.FixedPlayerStatsTables do
  @moduledoc """
  The FixedPlayerStatsTables context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.FixedPlayerStatsTables.FixedPlayerStatsTable

  @doc """
  Returns the list of fixed_player_stats_table.

  ## Examples

      iex> list_fixed_player_stats_table()
      [%FixedPlayerStatsTable{}, ...]

  """
  def list_fixed_player_stats_table do
    Repo.all(FixedPlayerStatsTable)
  end

  @doc """
  Gets a single fixed_player_stats_table.

  Raises `Ecto.NoResultsError` if the Fixed player stats table does not exist.

  ## Examples

      iex> get_fixed_player_stats_table!(123)
      %FixedPlayerStatsTable{}

      iex> get_fixed_player_stats_table!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixed_player_stats_table!(id), do: Repo.get!(FixedPlayerStatsTable, id)

  @doc """
  Gets a fixed_player_stats_table organization.

  Raises `Ecto.NoResultsError` if the Fixed player stats table does not exist.

  ## Examples

      iex> get_fixed_player_stats_table!(123)
      %FixedPlayerStatsTable{}

      iex> get_fixed_player_stats_table!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixed_player_stats_table_organization!(id) do
    {:ok, tournament} =
      Repo.get_by!(FixedPlayerStatsTable, id: id)
      |> Repo.preload(tournament: :organization)
      |> Map.fetch(:tournament)

    {:ok, organization} =
      tournament
      |> Map.fetch(:organization)

    organization
  end

  @doc """
  Creates a fixed_player_stats_table.

  ## Examples

      iex> create_fixed_player_stats_table(%{field: value})
      {:ok, %FixedPlayerStatsTable{}}

      iex> create_fixed_player_stats_table(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fixed_player_stats_table(attrs \\ %{}) do
    %FixedPlayerStatsTable{}
    |> FixedPlayerStatsTable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fixed_player_stats_table.

  ## Examples

      iex> update_fixed_player_stats_table(fixed_player_stats_table, %{field: new_value})
      {:ok, %FixedPlayerStatsTable{}}

      iex> update_fixed_player_stats_table(fixed_player_stats_table, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixed_player_stats_table(%FixedPlayerStatsTable{} = fixed_player_stats_table, attrs) do
    fixed_player_stats_table
    |> FixedPlayerStatsTable.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fixed_player_stats_table.

  ## Examples

      iex> delete_fixed_player_stats_table(fixed_player_stats_table)
      {:ok, %FixedPlayerStatsTable{}}

      iex> delete_fixed_player_stats_table(fixed_player_stats_table)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fixed_player_stats_table(%FixedPlayerStatsTable{} = fixed_player_stats_table) do
    Repo.delete(fixed_player_stats_table)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fixed_player_stats_table changes.

  ## Examples

      iex> change_fixed_player_stats_table(fixed_player_stats_table)
      %Ecto.Changeset{data: %FixedPlayerStatsTable{}}

  """
  def change_fixed_player_stats_table(
        %FixedPlayerStatsTable{} = fixed_player_stats_table,
        attrs \\ %{}
      ) do
    FixedPlayerStatsTable.changeset(fixed_player_stats_table, attrs)
  end
end
