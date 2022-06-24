defmodule KapselistudioWeb.WebsiteLive.ShowEpisode do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  @impl true
  def mount(%{"podcast_id" => podcast_id, "episode_id" => episode_id}, _session, socket) do
    with episode <- Media.get_published_episode!(podcast_id, episode_id),
         podcast <- Media.get_podcast_with_published_episodes!(podcast_id),
         shownotes <- Earmark.as_html!(episode.shownotes) do
      {:ok,
       socket
       |> assign(:podcast, podcast)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end
end
