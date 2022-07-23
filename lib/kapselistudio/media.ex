defmodule Kapselistudio.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Kapselistudio.Repo

  alias Kapselistudio.Media.Podcast
  alias Kapselistudio.Media.Episode
  alias Kapselistudio.Media.Tag

  def list_podcasts do
    Repo.all(Podcast)
  end

  # TODO: Implement and rename this to just do existance checking, as this is used when
  # verifying if the podcast exists in the subdomain resolving
  def get_podcast_for_slug(slug) do
    Repo.one(
      from(
        p in Podcast,
        where: p.slug == ^slug,
        select: p
      )
    )
  end

  def get_podcast_for_slug_with_episodes!(slug) do
    Repo.one!(
      from(
        p in Podcast,
        where: p.slug == ^slug,
        select: p,
        preload: [
          episodes:
            ^from(e in Episode, where: e.status == "PUBLISHED", order_by: [desc: e.number])
        ]
      )
    )
  end

  def get_podcast!(id) do
    Repo.one!(
      from(
        p in Podcast,
        where: p.id == ^id,
        select: p,
        preload: [
          episodes: ^from(e in Episode, order_by: [desc: e.number])
        ]
      )
    )
  end

  def get_podcast_with_published_episodes!(id) do
    Repo.one!(
      from(
        p in Podcast,
        where: p.id == ^id,
        select: p,
        preload: [
          episodes:
            ^from(e in Episode, where: e.status == "PUBLISHED", order_by: [desc: e.number])
        ]
      )
    )
  end

  def get_published_episode!(podcast_id, episode_id) do
    Repo.one!(
      from(
        e in Episode,
        where: e.id == ^episode_id and e.status == "PUBLISHED" and e.podcast_id == ^podcast_id
      )
    )
  end

  def create_podcast(attrs \\ %{}) do
    %Podcast{}
    |> Podcast.changeset(attrs)
    |> Repo.insert()
  end

  def update_podcast(%Podcast{} = podcast, attrs) do
    podcast
    |> Podcast.changeset(attrs)
    |> Repo.update()
  end

  def delete_podcast(%Podcast{} = podcast) do
    Repo.delete(podcast)
  end

  def change_podcast(%Podcast{} = podcast, attrs \\ %{}) do
    Podcast.changeset(podcast, attrs)
  end

  def get_episode!(id), do: Repo.get!(Episode, id) |> Repo.preload(:podcast)

  def get_published_episodes!(id) do
    query = from e in Episode, where: e.podcast_id == ^id and e.status == "PUBLISHED"

    Repo.all(query)
  end

  @doc """
  Returns a new, empty Episode with `number` set to currently largest episode
  number + 1.
  """
  def new_episode() do
    largest_number =
      Kapselistudio.Repo.one(
        from e in Episode,
          where: e.podcast_id == 1,
          select: e.number,
          order_by: [desc: :number],
          limit: 1
      )

    %Episode{number: largest_number + 1}
  end

  def create_episode(attrs \\ %{}) do
    %Episode{}
    |> Episode.changeset(attrs)
    |> Repo.insert()
  end

  def update_episode(%Episode{} = episode, attrs) do
    episode
    |> Episode.changeset(attrs)
    |> Repo.update()
  end

  def delete_episode(%Episode{} = episode) do
    Repo.delete(episode)
  end

  def change_episode(%Episode{} = episode, attrs \\ %{}) do
    Episode.changeset(episode, attrs)
  end

  #
  # Tags
  #

  def list_tags do
    Repo.all(Tag)
  end

  def get_tag!(id), do: Repo.get!(Tag, id)

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
