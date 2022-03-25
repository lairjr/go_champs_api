defmodule GoChampsApi.RecentlyViews do
  @moduledoc """
  The RecentlyViews context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.RecentlyViews.RecentlyView

  @doc """
  Returns the list of recently_view.

  ## Examples

      iex> list_recently_view()
      [%RecentlyView{}, ...]

  """
  def list_recently_view do
    query =
      from r in RecentlyView,
        group_by: r.tournament_id,
        select: %{
          tournament_id: r.tournament_id,
          views: count()
        },
        order_by: [desc: count()],
        preload: [:tournament]

    Repo.all(query)
  end

  @doc """
  Gets a single recently_view.

  Raises `Ecto.NoResultsError` if the Recently view does not exist.

  ## Examples

      iex> get_recently_view!(123)
      %RecentlyView{}

      iex> get_recently_view!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recently_view!(id), do: Repo.get!(RecentlyView, id)

  @doc """
  Creates a recently_view.

  ## Examples

      iex> create_recently_view(%{field: value})
      {:ok, %RecentlyView{}}

      iex> create_recently_view(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recently_view(attrs \\ %{}) do
    %RecentlyView{}
    |> RecentlyView.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recently_view changes.

  ## Examples

      iex> change_recently_view(recently_view)
      %Ecto.Changeset{data: %RecentlyView{}}

  """
  def change_recently_view(%RecentlyView{} = recently_view, attrs \\ %{}) do
    RecentlyView.changeset(recently_view, attrs)
  end
end
