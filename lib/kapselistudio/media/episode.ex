defmodule Kapselistudio.Media.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episodes" do
    field :duration, :integer
    field :number, :integer
    field :shownotes, :string
    field :title, :string
    field :url, :string
    belongs_to :podcast, Kapselistudio.Media.Podcast

    timestamps()
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:number, :url, :duration, :title, :shownotes])
    |> validate_required([:number, :url, :duration, :title, :shownotes])
  end
end
