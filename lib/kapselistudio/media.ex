defmodule Kapselistudio.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Kapselistudio.Repo

  alias Kapselistudio.Media.Podcast
  alias Kapselistudio.Media.Episode
  alias Kapselistudio.Media.Tag

  @doc """
  Returns the list of podcasts.

  ## Examples

      iex> list_podcasts()
      [%Podcast{}, ...]

  """
  def list_podcasts do
    Repo.all(Podcast)
  end

  @doc """
  Gets a single podcast.

  Raises `Ecto.NoResultsError` if the Podcast does not exist.

  ## Examples

      iex> get_podcast!(123)
      %Podcast{}

      iex> get_podcast!(456)
      ** (Ecto.NoResultsError)

  """
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

  @doc """
  Gets a single podcast with only published episodes.

  Raises `Ecto.NoResultsError` if the Podcast does not exist.

  ## Examples

      iex> get_podcast!(123)
      %Podcast{}

      iex> get_podcast!(456)
      ** (Ecto.NoResultsError)

  """
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

  @doc """
  Gets a single published podcast episode.

  Raises `Ecto.NoResultsError` if the Episode does not exist.
  """
  def get_published_episode!(podcast_id, episode_id) do
    Repo.one!(
      from(
        e in Episode,
        where: e.id == ^episode_id and e.status == "PUBLISHED" and e.podcast_id == ^podcast_id
      )
    )
  end

  @doc """
  Creates a podcast.

  ## Examples

      iex> create_podcast(%{field: value})
      {:ok, %Podcast{}}

      iex> create_podcast(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_podcast(attrs \\ %{}) do
    %Podcast{}
    |> Podcast.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a podcast.

  ## Examples

      iex> update_podcast(podcast, %{field: new_value})
      {:ok, %Podcast{}}

      iex> update_podcast(podcast, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_podcast(%Podcast{} = podcast, attrs) do
    podcast
    |> Podcast.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a podcast.

  ## Examples

      iex> delete_podcast(podcast)
      {:ok, %Podcast{}}

      iex> delete_podcast(podcast)
      {:error, %Ecto.Changeset{}}

  """
  def delete_podcast(%Podcast{} = podcast) do
    Repo.delete(podcast)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking podcast changes.

  ## Examples

      iex> change_podcast(podcast)
      %Ecto.Changeset{data: %Podcast{}}

  """
  def change_podcast(%Podcast{} = podcast, attrs \\ %{}) do
    Podcast.changeset(podcast, attrs)
  end

  @doc """
  Gets a single episode.

  Raises `Ecto.NoResultsError` if the Episode does not exist.

  ## Examples

      iex> get_episode!(123)
      %Episode{}

      iex> get_episode!(456)
      ** (Ecto.NoResultsError)

  """
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

  @doc """
  Creates a episode.

  ## Examples

      iex> create_episode(%{field: value})
      {:ok, %Episode{}}

      iex> create_episode(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_episode(attrs \\ %{}) do
    %Episode{}
    |> Episode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a episode.

  ## Examples

      iex> update_episode(episode, %{field: new_value})
      {:ok, %Episode{}}

      iex> update_episode(episode, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  def list_tags do
    Repo.all(Tag)
  end

  def get_tag!(id), do: Repo.get!(Tag, id)

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
