defmodule TournamentsApi.Tournaments.Tournament do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Organizations.Organization

  schema "tournaments" do
    field :name, :string
    field :link, :string
    field :team_stats_structure, :map

    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :link, :team_stats_structure, :organization_id])
    |> validate_required([:name])
  end
end
