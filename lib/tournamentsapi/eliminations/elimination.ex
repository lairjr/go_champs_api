defmodule TournamentsApi.Eliminations.Elimination do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Phases.Phase

  schema "eliminations" do
    field :title, :string

    embeds_many :team_stats, TeamStats, on_replace: :delete do
      field :team_id, :binary_id
      field :stats, :map
    end

    belongs_to :phase, Phase

    timestamps()
  end

  @doc false
  def changeset(elimination, attrs) do
    elimination
    |> cast(attrs, [:title, :phase_id])
    |> cast_embed(:team_stats, with: &team_stats_changeset/2)
    |> validate_required([:team_stats, :phase_id])
  end

  defp team_stats_changeset(schema, params) do
    schema
    |> cast(params, [:team_id, :stats])
  end
end
