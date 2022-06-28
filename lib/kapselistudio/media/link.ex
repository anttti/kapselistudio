defmodule Kapselistudio.Media.PodcastLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "podcast_links" do
    field :url, :string
    field :title, :string
    field :icon, :string

    belongs_to :podcast, Kapselistudio.Media.Podcast
  end

  @doc false
  def changeset(podcast_link, attrs) do
    podcast_link
    |> cast(attrs, [
      :url,
      :title,
      :icon,
      :podcast_id
    ])
    |> validate_required([
      :url,
      :title,
      :podcast_id
    ])
  end
end
