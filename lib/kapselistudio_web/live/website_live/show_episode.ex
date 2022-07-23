defmodule KapselistudioWeb.WebsiteLive.ShowEpisode do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.HeaderComponent

  @impl true
  def mount(%{"episode_id" => episode_id}, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    with podcast <- Media.get_podcast_for_slug_with_episodes!(subdomain),
         episode <- Media.get_published_episode!(podcast.id, episode_id),
         shownotes <- Earmark.as_html!(episode.shownotes) do
      {:ok,
       socket
       |> assign(:podcast, podcast)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end
end
