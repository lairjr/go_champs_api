defmodule GoChampsApi.PlayerStatsLogs do
  @moduledoc """
  The PlayerStatsLogs context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.PlayerStatsLogs.PlayerStatsLog

  @doc """
  Returns the list of player_stats_log.

  ## Examples

      iex> list_player_stats_log()
      [%PlayerStatsLog{}, ...]

  """
  def list_player_stats_log do
    Repo.all(PlayerStatsLog)
  end

  @doc """
  Gets a single player_stats_log.

  Raises `Ecto.NoResultsError` if the Player stats log does not exist.

  ## Examples

      iex> get_player_stats_log!(123)
      %PlayerStatsLog{}

      iex> get_player_stats_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_stats_log!(id), do: Repo.get!(PlayerStatsLog, id)

  @doc """
  Gets a player stats log organization for a given player stats log id.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_player_organization!(123)
      %Tournament{}

      iex> get_player_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_stats_log_organization!(id) do
    {:ok, tournament} =
      Repo.get_by!(PlayerStatsLog, id: id)
      |> Repo.preload(tournament: :organization)
      |> Map.fetch(:tournament)

    {:ok, organization} =
      tournament
      |> Map.fetch(:organization)

    organization
  end

  @doc """
  Gets a player_stats_logs tournament id.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

  iex> get_player_stats_logs_tournament_id!(123)
  %Tournament{}

  iex> get_player_stats_logs_tournament_id!(456)
  ** (Ecto.NoResultsError)

  """
  def get_player_stats_logs_tournament_id(player_stats_logs) do
    player_stats_logs_id =
      Enum.map(player_stats_logs, fn player_stats_log -> player_stats_log["id"] end)

    case Repo.all(
           from player_stats_log in PlayerStatsLog,
             where: player_stats_log.id in ^player_stats_logs_id,
             group_by: player_stats_log.tournament_id,
             select: player_stats_log.tournament_id
         ) do
      [tournament_id] ->
        {:ok, tournament_id}

      _ ->
        {:error, "Can only update player_stats_log from same tournament"}
    end
  end

  @doc """
  Creates a player_stats_log.

  ## Examples

      iex> create_player_stats_log(%{field: value})
      {:ok, %PlayerStatsLog{}}

      iex> create_player_stats_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_stats_log(attrs \\ %{}) do
    %PlayerStatsLog{}
    |> PlayerStatsLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create many player stats logs.

  ## Examples

      iex> create_player_stats_logs([%{field: new_value}])
      {:ok, [%PlayerStatsLog{}]}

      iex> create_player_stats_logs([%{field: bad_value}])
      {:error, %Ecto.Changeset{}}

  """
  def create_player_stats_logs(player_stats_logs) do
    {multi, _} =
      player_stats_logs
      |> Enum.reduce({Ecto.Multi.new(), 0}, fn player_stats_log, {multi, index} ->
        changeset =
          %PlayerStatsLog{}
          |> PlayerStatsLog.changeset(player_stats_log)

        {Ecto.Multi.insert(multi, index, changeset), index + 1}
      end)

    Repo.transaction(multi)
  end

  @doc """
  Updates a player_stats_log.

  ## Examples

      iex> update_player_stats_log(player_stats_log, %{field: new_value})
      {:ok, %PlayerStatsLog{}}

      iex> update_player_stats_log(player_stats_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_stats_log(%PlayerStatsLog{} = player_stats_log, attrs) do
    player_stats_log
    |> PlayerStatsLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates many player stats logs.

  ## Examples

      iex> update_player_stats_logs([%{field: new_value}])
      {:ok, [%PlayerStatsLog{}]}

      iex> update_player_stats_logs([%{field: bad_value}])
      {:error, %Ecto.Changeset{}}

  """
  def update_player_stats_logs(player_stats_logs) do
    multi =
      player_stats_logs
      |> Enum.reduce(Ecto.Multi.new(), fn player_stats_log, multi ->
        %{"id" => id} = player_stats_log
        current_player_stats_log = Repo.get_by!(PlayerStatsLog, id: id)
        changeset = PlayerStatsLog.changeset(current_player_stats_log, player_stats_log)

        Ecto.Multi.update(multi, id, changeset)
      end)

    Repo.transaction(multi)
  end

  @doc """
  Deletes a player_stats_log.

  ## Examples

      iex> delete_player_stats_log(player_stats_log)
      {:ok, %PlayerStatsLog{}}

      iex> delete_player_stats_log(player_stats_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_stats_log(%PlayerStatsLog{} = player_stats_log) do
    Repo.delete(player_stats_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_stats_log changes.

  ## Examples

      iex> change_player_stats_log(player_stats_log)
      %Ecto.Changeset{source: %PlayerStatsLog{}}

  """
  def change_player_stats_log(%PlayerStatsLog{} = player_stats_log) do
    PlayerStatsLog.changeset(player_stats_log, %{})
  end
end
