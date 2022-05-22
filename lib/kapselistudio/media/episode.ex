defmodule Kapselistudio.Media.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episodes" do
    field :duration, :integer
    field :number, :integer
    field :description, :string, default: ""
    field :shownotes, :string, default: ""
    field :title, :string
    field :url, :string
    field :status, :string, default: "DRAFT"
    field :published_at, :utc_datetime
    belongs_to :podcast, Kapselistudio.Media.Podcast

    timestamps()
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [
      :number,
      :url,
      :duration,
      :title,
      :description,
      :shownotes,
      :status,
      :published_at,
      :podcast_id
    ])
    # TODO: Validate that status is either DRAFT or PUBLISHED
    |> validate_required([
      :number,
      :title,
      :status,
      :podcast_id
    ])
  end
end
