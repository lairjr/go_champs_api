defmodule TournamentsApi.Tournaments.Tournament do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset

  schema "tournaments" do
    field :name, :string
    field :link, :string

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :link])
    |> validate_required([:name])
  end
end
