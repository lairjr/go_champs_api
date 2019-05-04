defmodule TournamentsApi.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Tournaments.Tournament

  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments()
      [%Tournament{}, ...]

  """
  def list_tournaments do
    Repo.all(Tournament)
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(123)
      %Tournament{}

      iex> get_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(id), do: Repo.get!(Tournament, id)

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tournament.

  ## Examples

      iex> delete_tournament(tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(tournament)
      %Ecto.Changeset{source: %Tournament{}}

  """
  def change_tournament(%Tournament{} = tournament) do
    Tournament.changeset(tournament, %{})
  end

  alias TournamentsApi.Tournaments.TournamentGroup

  @doc """
  Returns the list of tournament_groups.

  ## Examples

      iex> list_tournament_groups()
      [%TournamentGroup{}, ...]

  """
  def list_tournament_groups(tournament_id) do
    Repo.all(TournamentGroup, tournament_id: tournament_id)
  end

  @doc """
  Gets a single tournament_group.

  Raises `Ecto.NoResultsError` if the TournamentGroup does not exist.

  ## Examples

      iex> get_tournament_group!(123)
      %TournamentGroup{}

      iex> get_tournament_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_group!(id, tournament_id),
    do: Repo.get_by!(TournamentGroup, id: id, tournament_id: tournament_id)

  @doc """
  Creates a tournament_group.

  ## Examples

      iex> create_tournament_group(%{field: value})
      {:ok, %TournamentGroup{}}

      iex> create_tournament_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_group(attrs \\ %{}) do
    %TournamentGroup{}
    |> TournamentGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_group.

  ## Examples

      iex> update_tournament_group(tournament_group, %{field: new_value})
      {:ok, %TournamentGroup{}}

      iex> update_tournament_group(tournament_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_group(%TournamentGroup{} = tournament_group, attrs) do
    tournament_group
    |> TournamentGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TournamentGroup.

  ## Examples

      iex> delete_tournament_group(tournament_group)
      {:ok, %TournamentGroup{}}

      iex> delete_tournament_group(tournament_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_group(%TournamentGroup{} = tournament_group) do
    Repo.delete(tournament_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_group changes.

  ## Examples

      iex> change_tournament_group(tournament_group)
      %Ecto.Changeset{source: %TournamentGroup{}}

  """
  def change_tournament_group(%TournamentGroup{} = tournament_group) do
    TournamentGroup.changeset(tournament_group, %{})
  end

  alias TournamentsApi.Tournaments.TournamentTeam

  @doc """
  Returns the list of tournament_teams.

  ## Examples

      iex> list_tournament_teams()
      [%TournamentTeam{}, ...]

  """
  def list_tournament_teams(tournament_id) do
    Repo.all(TournamentTeam, tournament_id: tournament_id)
  end

  @doc """
  Gets a single tournament_team.

  Raises `Ecto.NoResultsError` if the Tournament team does not exist.

  ## Examples

      iex> get_tournament_team!(123)
      %TournamentTeam{}

      iex> get_tournament_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_team!(id, tournament_id),
    do: Repo.get_by!(TournamentTeam, id: id, tournament_id: tournament_id)

  @doc """
  Creates a tournament_team.

  ## Examples

      iex> create_tournament_team(%{field: value})
      {:ok, %TournamentTeam{}}

      iex> create_tournament_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_team(attrs \\ %{}) do
    %TournamentTeam{}
    |> TournamentTeam.changeset(attrs)
    |> Ecto.Changeset.put_change(:tournament_group, attrs["tournament_group_id"])
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_team.

  ## Examples

      iex> update_tournament_team(tournament_team, %{field: new_value})
      {:ok, %TournamentTeam{}}

      iex> update_tournament_team(tournament_team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_team(%TournamentTeam{} = tournament_team, attrs) do
    tournament_team
    |> TournamentTeam.changeset(attrs)
    |> Ecto.Changeset.put_change(:tournament_group, attrs["tournament_group_id"])
    |> Repo.update()
  end

  @doc """
  Deletes a TournamentTeam.

  ## Examples

      iex> delete_tournament_team(tournament_team)
      {:ok, %TournamentTeam{}}

      iex> delete_tournament_team(tournament_team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_team(%TournamentTeam{} = tournament_team) do
    Repo.delete(tournament_team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_team changes.

  ## Examples

      iex> change_tournament_team(tournament_team)
      %Ecto.Changeset{source: %TournamentTeam{}}

  """
  def change_tournament_team(%TournamentTeam{} = tournament_team) do
    TournamentTeam.changeset(tournament_team, %{})
  end
end
