defmodule KapselistudioWeb.WebsiteLive.Show do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    {:ok,
     socket
     |> assign(:podcast, Media.get_podcast_for_slug_with_episodes!(subdomain))
     |> assign(:playing_url, nil)
     |> assign(:page, :podcast)}
  end

  @impl true
  def handle_params(%{"episode_id" => episode_id}, _session, socket) do
    with episode <- Media.get_published_episode!(socket.assigns.podcast.id, episode_id),
         shownotes <- Earmark.as_html!(episode.shownotes) do
      {:noreply,
       socket
       |> assign(:page, :episode)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply, assign(socket, :page, :podcast)}
  end

  @impl true
  def handle_event("show-episode", %{"episode" => id}, socket) do
    url =
      KapselistudioWeb.SubdomainRouter.Helpers.website_show_path(
        socket,
        :show_episode,
        id
      )

    {:noreply,
     socket
     |> push_patch(to: url)}
  end

  @impl true
  def handle_event("show-podcast", _params, socket) do
    url =
      KapselistudioWeb.SubdomainRouter.Helpers.website_show_path(
        socket,
        :show
      )

    IO.inspect(url)

    {:noreply,
     socket
     |> push_patch(to: url)}
  end

  @impl true
  def handle_event("play-episode", %{"url" => url}, socket) do
    {:noreply, assign(socket, :playing_url, url)}
  end
end
