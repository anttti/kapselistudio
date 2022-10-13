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
    field :image, :string
    field :explicit, :boolean
    field :episode_type, :string
    field :author, :string
    field :filesize, :integer
    field :guid, :string

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
      :podcast_id,
      :image,
      :explicit,
      :episode_type,
      :author,
      :filesize,
      :guid
    ])
    # TODO: Validate that status is either DRAFT or PUBLISHED
    |> validate_required([
      :number,
      :title,
      :status,
      :podcast_id,
      :guid
    ])
  end
end
