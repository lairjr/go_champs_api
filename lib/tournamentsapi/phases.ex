defmodule TournamentsApi.Phases do
  @moduledoc """
  The Phases context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Phases.PhaseStandings

  @doc """
  Returns the list of phase_standings.

  ## Examples

      iex> list_phase_standings()
      [%PhaseStandings{}, ...]

  """
  def list_phase_standings(tournament_phase_id) do
    {:ok, uuid} = Ecto.UUID.cast(tournament_phase_id)

    PhaseStandings
    |> where([s], s.tournament_phase_id == ^uuid)
    |> Repo.all()
  end

  @doc """
  Gets a single phase_standings.

  Raises `Ecto.NoResultsError` if the Phase standings does not exist.

  ## Examples

      iex> get_phase_standings!(123)
      %PhaseStandings{}

      iex> get_phase_standings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phase_standings!(id, tournament_phase_id),
    do: Repo.get!(PhaseStandings, id, tournament_phase_id: tournament_phase_id)

  @doc """
  Creates a phase_standings.

  ## Examples

      iex> create_phase_standings(%{field: value})
      {:ok, %PhaseStandings{}}

      iex> create_phase_standings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phase_standings(attrs \\ %{}) do
    %PhaseStandings{}
    |> PhaseStandings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a phase_standings.

  ## Examples

      iex> update_phase_standings(phase_standings, %{field: new_value})
      {:ok, %PhaseStandings{}}

      iex> update_phase_standings(phase_standings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phase_standings(%PhaseStandings{} = phase_standings, attrs) do
    phase_standings
    |> PhaseStandings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PhaseStandings.

  ## Examples

      iex> delete_phase_standings(phase_standings)
      {:ok, %PhaseStandings{}}

      iex> delete_phase_standings(phase_standings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phase_standings(%PhaseStandings{} = phase_standings) do
    Repo.delete(phase_standings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phase_standings changes.

  ## Examples

      iex> change_phase_standings(phase_standings)
      %Ecto.Changeset{source: %PhaseStandings{}}

  """
  def change_phase_standings(%PhaseStandings{} = phase_standings) do
    PhaseStandings.changeset(phase_standings, %{})
  end
end
