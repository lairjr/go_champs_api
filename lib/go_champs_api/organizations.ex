defmodule GoChampsApi.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.Organizations.Organization
  alias GoChampsApi.Tournaments.Tournament

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization_changeset =
      organization
      |> Organization.changeset(attrs)

    if Map.has_key?(attrs, :slug) do
      associated_tournaments_query =
        from t in Tournament,
          where: t.organization_id == ^Ecto.Changeset.get_field(organization_changeset, :id)

      Ecto.Multi.new()
      |> Ecto.Multi.update(:organization, organization_changeset)
      |> Ecto.Multi.update_all(:tournaments, associated_tournaments_query,
        set: [organization_slug: Ecto.Changeset.get_change(organization_changeset, :slug)]
      )
      |> Repo.transaction()
    else
      Ecto.Multi.new()
      |> Ecto.Multi.update(:organization, organization_changeset)
      |> Repo.transaction()
    end
  end

  @doc """
  Deletes a Organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{source: %Organization{}}

  """
  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end
end
