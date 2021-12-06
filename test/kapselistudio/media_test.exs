defmodule Kapselistudio.MediaTest do
  use Kapselistudio.DataCase

  alias Kapselistudio.Media

  describe "podcasts" do
    alias Kapselistudio.Media.Podcast

    import Kapselistudio.MediaFixtures

    @invalid_attrs %{name: nil}

    test "list_podcasts/0 returns all podcasts" do
      podcast = podcast_fixture()
      assert Media.list_podcasts() == [podcast]
    end

    test "get_podcast!/1 returns the podcast with given id" do
      podcast = podcast_fixture()
      assert Media.get_podcast!(podcast.id) == podcast
    end

    test "create_podcast/1 with valid data creates a podcast" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Podcast{} = podcast} = Media.create_podcast(valid_attrs)
      assert podcast.name == "some name"
    end

    test "create_podcast/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_podcast(@invalid_attrs)
    end

    test "update_podcast/2 with valid data updates the podcast" do
      podcast = podcast_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Podcast{} = podcast} = Media.update_podcast(podcast, update_attrs)
      assert podcast.name == "some updated name"
    end

    test "update_podcast/2 with invalid data returns error changeset" do
      podcast = podcast_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_podcast(podcast, @invalid_attrs)
      assert podcast == Media.get_podcast!(podcast.id)
    end

    test "delete_podcast/1 deletes the podcast" do
      podcast = podcast_fixture()
      assert {:ok, %Podcast{}} = Media.delete_podcast(podcast)
      assert_raise Ecto.NoResultsError, fn -> Media.get_podcast!(podcast.id) end
    end

    test "change_podcast/1 returns a podcast changeset" do
      podcast = podcast_fixture()
      assert %Ecto.Changeset{} = Media.change_podcast(podcast)
    end
  end

  describe "episodes" do
    alias Kapselistudio.Media.Episode

    import Kapselistudio.MediaFixtures

    @invalid_attrs %{duration: nil, number: nil, shownotes: nil, title: nil, url: nil}

    test "list_episodes/0 returns all episodes" do
      episode = episode_fixture()
      assert Media.list_episodes() == [episode]
    end

    test "get_episode!/1 returns the episode with given id" do
      episode = episode_fixture()
      assert Media.get_episode!(episode.id) == episode
    end

    test "create_episode/1 with valid data creates a episode" do
      valid_attrs = %{
        duration: 42,
        number: 42,
        shownotes: "some shownotes",
        title: "some title",
        url: "some url"
      }

      assert {:ok, %Episode{} = episode} = Media.create_episode(valid_attrs)
      assert episode.duration == 42
      assert episode.number == 42
      assert episode.shownotes == "some shownotes"
      assert episode.title == "some title"
      assert episode.url == "some url"
    end

    test "create_episode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_episode(@invalid_attrs)
    end

    test "update_episode/2 with valid data updates the episode" do
      episode = episode_fixture()

      update_attrs = %{
        duration: 43,
        number: 43,
        shownotes: "some updated shownotes",
        title: "some updated title",
        url: "some updated url"
      }

      assert {:ok, %Episode{} = episode} = Media.update_episode(episode, update_attrs)
      assert episode.duration == 43
      assert episode.number == 43
      assert episode.shownotes == "some updated shownotes"
      assert episode.title == "some updated title"
      assert episode.url == "some updated url"
    end

    test "update_episode/2 with invalid data returns error changeset" do
      episode = episode_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_episode(episode, @invalid_attrs)
      assert episode == Media.get_episode!(episode.id)
    end

    test "delete_episode/1 deletes the episode" do
      episode = episode_fixture()
      assert {:ok, %Episode{}} = Media.delete_episode(episode)
      assert_raise Ecto.NoResultsError, fn -> Media.get_episode!(episode.id) end
    end

    test "change_episode/1 returns a episode changeset" do
      episode = episode_fixture()
      assert %Ecto.Changeset{} = Media.change_episode(episode)
    end
  end

  describe "tags" do
    alias Kapselistudio.Media.Tag

    import Kapselistudio.MediaFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Media.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Media.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Tag{} = tag} = Media.create_tag(valid_attrs)
      assert tag.name == "some name"
      assert tag.slug == "some slug"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Tag{} = tag} = Media.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
      assert tag.slug == "some updated slug"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_tag(tag, @invalid_attrs)
      assert tag == Media.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Media.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Media.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Media.change_tag(tag)
    end
  end
end
