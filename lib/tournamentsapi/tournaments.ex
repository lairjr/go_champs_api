defmodule TournamentsApi.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Organizations.Organization

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
  Returns the list of tournaments filter by keywork param.

  ## Examples

      iex> list_tournaments([name: "some name"])
      [%Tournament{}, ...]

  """
  def list_tournaments(where) do
    query = from t in Tournament, where: ^where
    Repo.all(query)
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
  def get_tournament!(id) do
    Tournament
    |> Repo.get!(id)
    |> Repo.preload([:organization, :phases, :teams])
  end

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}n

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> map_organization_slug()
    |> Repo.insert()
  end

  defp map_organization_slug(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        organization_id = Ecto.Changeset.get_change(changeset, :organization_id)
        organization = Repo.get(Organization, organization_id)
        Ecto.Changeset.put_change(changeset, :organization_slug, organization.slug)

      _ ->
        changeset
    end
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

  alias TournamentsApi.Tournaments.TournamentStat

  @doc """
  Returns the list of tournament_stats.

  ## Examples

      iex> list_tournament_stats()
      [%TournamentStat{}, ...]

  """
  def list_tournament_stats(phase_id) do
    {:ok, uuid} = Ecto.UUID.cast(phase_id)

    TournamentStat
    |> where([s], s.phase_id == ^uuid)
    |> Repo.all()
  end

  @doc """
  Gets a single tournament_stat.

  Raises `Ecto.NoResultsError` if the Tournament stat does not exist.

  ## Examples

      iex> get_tournament_stat!(123)
      %TournamentStat{}

      iex> get_tournament_stat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_stat!(id, phase_id),
    do: Repo.get_by!(TournamentStat, id: id, phase_id: phase_id)

  @doc """
  Creates a tournament_stat.

  ## Examples

      iex> create_tournament_stat(%{field: value})
      {:ok, %TournamentStat{}}

      iex> create_tournament_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_stat(attrs \\ %{}) do
    %TournamentStat{}
    |> TournamentStat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_stat.

  ## Examples

      iex> update_tournament_stat(tournament_stat, %{field: new_value})
      {:ok, %TournamentStat{}}

      iex> update_tournament_stat(tournament_stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_stat(%TournamentStat{} = tournament_stat, attrs) do
    tournament_stat
    |> TournamentStat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TournamentStat.

  ## Examples

      iex> delete_tournament_stat(tournament_stat)
      {:ok, %TournamentStat{}}

      iex> delete_tournament_stat(tournament_stat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_stat(%TournamentStat{} = tournament_stat) do
    Repo.delete(tournament_stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_stat changes.

  ## Examples

      iex> change_tournament_stat(tournament_stat)
      %Ecto.Changeset{source: %TournamentStat{}}

  """
  def change_tournament_stat(%TournamentStat{} = tournament_stat) do
    TournamentStat.changeset(tournament_stat, %{})
  end
end
