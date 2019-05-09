defmodule TournamentsApi.Teams.Team do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
  end
end
