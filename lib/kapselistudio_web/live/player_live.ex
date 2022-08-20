defmodule KapselistudioWeb.PlayerLive do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media

  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    podcast = Media.get_podcast_for_slug_with_episodes!(subdomain, 0, 1)
    newest_episode = List.first(podcast.episodes)

    {:ok, assign(socket, :episode, newest_episode), layout: false}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-secondary h-[110px]">
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
end
