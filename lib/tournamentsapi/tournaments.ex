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
  Search tournaments.
  """
  def search_tournaments(term) do
    search_term = "%#{term}%"

    query =
      from t in Tournament, where: ilike(t.name, ^search_term) or ilike(t.slug, ^search_term)

    Repo.all(query)
    |> Repo.preload([:organization])
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
end
