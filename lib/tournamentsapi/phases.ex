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
      |> Repo.preload([:rounds, :stats, :standings])

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

  alias TournamentsApi.Phases.PhaseStandings

  @doc """
  Returns the list of phase_standings.

  ## Examples

      iex> list_phase_standings()
      [%PhaseStandings{}, ...]

  """
  def list_phase_standings(phase_id) do
    {:ok, uuid} = Ecto.UUID.cast(phase_id)

    PhaseStandings
    |> where([s], s.phase_id == ^uuid)
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
  def get_phase_standings!(id, phase_id),
    do: Repo.get!(PhaseStandings, id, phase_id: phase_id)

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

  alias TournamentsApi.Phases.PhaseRound

  @doc """
  Returns the list of phase_rounds.

  ## Examples

      iex> list_phase_rounds()
      [%PhaseRound{}, ...]

  """
  def list_phase_rounds(phase_id) do
    {:ok, uuid} = Ecto.UUID.cast(phase_id)

    PhaseRound
    |> where([s], s.phase_id == ^uuid)
    |> Repo.all()
  end

  @doc """
  Gets a single phase_round.

  Raises `Ecto.NoResultsError` if the Phase round does not exist.

  ## Examples

      iex> get_phase_round!(123)
      %PhaseRound{}

      iex> get_phase_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phase_round!(id, phase_id),
    do: Repo.get!(PhaseRound, id, phase_id: phase_id)

  @doc """
  Creates a phase_round.

  ## Examples

      iex> create_phase_round(%{field: value})
      {:ok, %PhaseRound{}}

      iex> create_phase_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phase_round(attrs \\ %{}) do
    %PhaseRound{}
    |> PhaseRound.changeset(attrs)
    |> get_phase_round_next_order()
    |> Repo.insert()
  end

  defp get_phase_round_next_order(changeset) do
    phase_id = Ecto.Changeset.get_field(changeset, :phase_id)

    if phase_id do
      number_of_records =
        PhaseRound
        |> where([s], s.phase_id == ^phase_id)
        |> Repo.aggregate(:count, :id)

      Ecto.Changeset.put_change(changeset, :order, Enum.sum([number_of_records, 1]))
    else
      changeset
    end
  end

  @doc """
  Updates a phase_round.

  ## Examples

      iex> update_phase_round(phase_round, %{field: new_value})
      {:ok, %PhaseRound{}}

      iex> update_phase_round(phase_round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phase_round(%PhaseRound{} = phase_round, attrs) do
    phase_round
    |> PhaseRound.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PhaseRound.

  ## Examples

      iex> delete_phase_round(phase_round)
      {:ok, %PhaseRound{}}

      iex> delete_phase_round(phase_round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phase_round(%PhaseRound{} = phase_round) do
    Repo.delete(phase_round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phase_round changes.

  ## Examples

      iex> change_phase_round(phase_round)
      %Ecto.Changeset{source: %PhaseRound{}}

  """
  def change_phase_round(%PhaseRound{} = phase_round) do
    PhaseRound.changeset(phase_round, %{})
  end
end
