defmodule GoChampsApi.Eliminations do
  @moduledoc """
  The Eliminations context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.Eliminations.Elimination
  alias GoChampsApi.Phases

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

  def get_elimination_organization!(id) do
    {:ok, phase} =
      Repo.get!(Elimination, id)
      |> Repo.preload([:phase])
      |> Map.fetch(:phase)

    Phases.get_phase_organization!(phase.id)
  end

  @doc """
  Gets a eliminations phase id.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

  iex> get_eliminations_phase_id([])
  [%Elimination{}]

  iex> get_eliminations_phase_id([])
  ** (Ecto.NoResultsError)

  """
  def get_eliminations_phase_id(eliminations) do
    eliminations_id = Enum.map(eliminations, fn elimination -> elimination["id"] end)

    case Repo.all(
           from elimination in Elimination,
             where: elimination.id in ^eliminations_id,
             group_by: elimination.phase_id,
             select: elimination.phase_id
         ) do
      [phase_id] ->
        {:ok, phase_id}

      _ ->
        {:error, "Can only update elimination from same phase"}
    end
  end

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
    |> get_elimination_next_order()
    |> Repo.insert()
  end

  defp get_elimination_next_order(changeset) do
    phase_id = Ecto.Changeset.get_field(changeset, :phase_id)

    query =
      if phase_id do
        from e in Elimination, where: e.phase_id == ^phase_id
      else
        from(e in Elimination)
      end

    number_of_records = Repo.aggregate(query, :count, :id)
    Ecto.Changeset.put_change(changeset, :order, Enum.sum([number_of_records, 1]))
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
  Updates many eliminations.

  ## Examples

      iex> update_eliminations([%{field: new_value}])
      {:ok, [%Phase{}]}

      iex> update_eliminations([%{field: bad_value}])
      {:error, %Ecto.Changeset{}}

  """
  def update_eliminations(eliminations) do
    multi =
      eliminations
      |> Enum.reduce(Ecto.Multi.new(), fn elimination, multi ->
        %{"id" => id} = elimination
        current_elimination = Repo.get_by!(Elimination, id: id)
        changeset = Elimination.changeset(current_elimination, elimination)

        Ecto.Multi.update(multi, id, changeset)
      end)

    Repo.transaction(multi)
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
