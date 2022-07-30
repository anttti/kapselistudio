defmodule KapselistudioWeb.WebsiteLive.Show do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.HeaderComponent
  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    {:ok,
     socket
     |> assign(:podcast, Media.get_podcast_for_slug_with_episodes!(subdomain))
     |> assign(:playing_episode?, false)
     |> assign(:page, :podcast)}
  end

  @impl true
  def handle_event("show-episode", %{"episode" => id}, socket) do
    IO.inspect("Showing #{id}")

    with episode <- Media.get_published_episode!(socket.assigns.podcast.id, id),
         shownotes <- Earmark.as_html!(episode.shownotes) do
      {:noreply,
       socket
       |> assign(:page, :episode)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end
end
