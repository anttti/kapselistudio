defmodule KapselistudioWeb.FeedView do
  use KapselistudioWeb, :view

  def render("episodes.json", %{episodes: episodes}) do
    %{
      collection: episodes
    }
  end

  def render("episode.json", %{episode: episode}) do
    episode
  end
end
