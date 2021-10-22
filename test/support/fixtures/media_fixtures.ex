defmodule Kapselistudio.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kapselistudio.Media` context.
  """

  @doc """
  Generate a podcast.
  """
  def podcast_fixture(attrs \\ %{}) do
    {:ok, podcast} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Kapselistudio.Media.create_podcast()

    podcast
  end

  @doc """
  Generate a episode.
  """
  def episode_fixture(attrs \\ %{}) do
    {:ok, episode} =
      attrs
      |> Enum.into(%{
        duration: 42,
        number: 42,
        shownotes: "some shownotes",
        title: "some title",
        url: "some url"
      })
      |> Kapselistudio.Media.create_episode()

    episode
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some slug"
      })
      |> Kapselistudio.Media.create_tag()

    tag
  end
end
