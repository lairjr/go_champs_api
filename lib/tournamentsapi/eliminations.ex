defmodule TournamentsApi.Eliminations do
  @moduledoc """
  The Eliminations context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Eliminations.Elimination

  @doc """
  Gets a single elimination.

  Raises `Ecto.NoResultsError` if the Elimination does not exist.

  ## Examples

      iex> get_elimination!(123)
      %Elimination{}

      iex> get_elimination!(456)
      ** (Ecto.NoResultsError)

  """
  def get_elimination!(id), do: Repo.get!(Elimination, id)

  @doc """
  Creates a elimination.

  ## Examples

      iex> create_elimination(%{field: value})
      {:ok, %Elimination{}}

      iex> create_elimination(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_elimination(attrs \\ %{}) do
    %Elimination{}
    |> Elimination.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a elimination.

  ## Examples

      iex> update_elimination(elimination, %{field: new_value})
      {:ok, %Elimination{}}

      iex> update_elimination(elimination, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_elimination(%Elimination{} = elimination, attrs) do
    elimination
    |> Elimination.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Elimination.

  ## Examples

      iex> delete_elimination(elimination)
      {:ok, %Elimination{}}

      iex> delete_elimination(elimination)
      {:error, %Ecto.Changeset{}}

  """
  def delete_elimination(%Elimination{} = elimination) do
    Repo.delete(elimination)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking elimination changes.

  ## Examples

      iex> change_elimination(elimination)
      %Ecto.Changeset{source: %Elimination{}}

  """
  def change_elimination(%Elimination{} = elimination) do
    Elimination.changeset(elimination, %{})
  end
end
