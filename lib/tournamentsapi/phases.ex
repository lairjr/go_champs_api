defmodule TournamentsApi.Phases do
  @moduledoc """
  The Phases context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Phases.Phase

  @doc """
  Gets a single phase.

  Raises `Ecto.NoResultsError` if the Tournament phase does not exist.

  ## Examples

      iex> get_phase!(123)
      %Phase{}

      iex> get_phase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phase!(id),
    do:
      Repo.get_by!(Phase, id: id)
      |> Repo.preload([:draws, :eliminations, :stats])

  @doc """
  Creates a phase.

  ## Examples

      iex> create_phase(%{field: value})
      {:ok, %Phase{}}

      iex> create_phase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phase(attrs \\ %{}) do
    %Phase{}
    |> Phase.changeset(attrs)
    |> get_phase_next_order()
    |> Repo.insert()
  end

  defp get_phase_next_order(changeset) do
    tournament_id = Ecto.Changeset.get_field(changeset, :tournament_id)
    number_of_records = Repo.aggregate(Phase, :count, :id, tournament_id: tournament_id)
    Ecto.Changeset.put_change(changeset, :order, Enum.sum([number_of_records, 1]))
  end

  @doc """
  Updates a phase.

  ## Examples

      iex> update_phase(phase, %{field: new_value})
      {:ok, %Phase{}}

      iex> update_phase(phase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phase(%Phase{} = phase, attrs) do
    phase
    |> Phase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Phase.

  ## Examples

      iex> delete_phase(phase)
      {:ok, %Phase{}}

      iex> delete_phase(phase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phase(%Phase{} = phase) do
    Repo.delete(phase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phase changes.

  ## Examples

      iex> change_phase(phase)
      %Ecto.Changeset{source: %Phase{}}

  """
  def change_phase(%Phase{} = phase) do
    Phase.changeset(phase, %{})
  end
end
