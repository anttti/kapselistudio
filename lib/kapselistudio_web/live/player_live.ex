defmodule KapselistudioWeb.PlayerLive do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-gray-200 flex justify-center fixed z-50 left-0 right-0 bottom-0">
      <podcast-player
        id="podcast-player"
        phx-update="ignore"
        data-title={@episode.title}
        data-number={@episode.number}
      >
        <audio id="audio-player" controls="controls" preload="none" width="100%" src={@episode.url}>
        </audio>
      </podcast-player>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    podcast = Media.get_podcast_for_slug_with_episodes!(subdomain)
    newest_episode = List.first(podcast.episodes)

    {:ok, assign(socket, :episode, newest_episode), layout: false}
  end
end
