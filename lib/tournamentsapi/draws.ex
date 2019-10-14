defmodule TournamentsApi.Draws do
  @moduledoc """
  The Draws context.
  """

  import Ecto.Query, warn: false
  alias TournamentsApi.Repo

  alias TournamentsApi.Draws.Draw

  @doc """
  Gets a single draw.

  Raises `Ecto.NoResultsError` if the Draw does not exist.

  ## Examples

      iex> get_draw!(123)
      %Draw{}

      iex> get_draw!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draw!(id), do: Repo.get!(Draw, id)

  @doc """
  Creates a draw.

  ## Examples

      iex> create_draw(%{field: value})
      {:ok, %Draw{}}

      iex> create_draw(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draw(attrs \\ %{}) do
    %Draw{}
    |> Draw.changeset(attrs)
    |> get_draw_next_order()
    |> Repo.insert()
  end

  defp get_draw_next_order(changeset) do
    phase_id = Ecto.Changeset.get_field(changeset, :phase_id)

    if phase_id do
      number_of_records =
        Draw
        |> where([s], s.phase_id == ^phase_id)
        |> Repo.aggregate(:count, :id)

      Ecto.Changeset.put_change(changeset, :order, Enum.sum([number_of_records, 1]))
    else
      changeset
    end
  end

  @doc """
  Updates a draw.

  ## Examples

      iex> update_draw(draw, %{field: new_value})
      {:ok, %Draw{}}

      iex> update_draw(draw, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draw(%Draw{} = draw, attrs) do
    draw
    |> Draw.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Draw.

  ## Examples

      iex> delete_draw(draw)
      {:ok, %Draw{}}

      iex> delete_draw(draw)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draw(%Draw{} = draw) do
    Repo.delete(draw)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draw changes.

  ## Examples

      iex> change_draw(draw)
      %Ecto.Changeset{source: %Draw{}}

  """
  def change_draw(%Draw{} = draw) do
    Draw.changeset(draw, %{})
  end
end
