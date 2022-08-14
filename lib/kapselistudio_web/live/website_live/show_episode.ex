defmodule KapselistudioWeb.WebsiteLive.ShowEpisode do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(%{"episode_id" => episode_id}, _session, socket) do
    with %URI{host: host} = socket.host_uri,
         subdomain = Kapselistudio.Origin.get_subdomain(host),
         podcast = Media.get_podcast_for_slug_with_all_episodes!(subdomain),
         episode <- Media.get_published_episode!(podcast.id, episode_id),
         shownotes <- Earmark.as_html!(episode.shownotes) do
      {:ok,
       socket
       |> assign(:podcast, podcast)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.page name={@podcast.name} description={@podcast.description} author={@podcast.author}>
      <section class="flex-1 p-8 flex flex-col gap-4 lg:ml-80">
        <h1 class="text-3xl font-medium text-gray-900">
          <%= @episode.title %>
        </h1>

        <button
          class="text-sm border border-gray-400 px-4 py-2 play-button"
          data-url={@episode.url}
          data-title={@episode.title}
          data-number={@episode.number}
        >
          Kuuntele jakso
        </button>

        <div class="prose prose-sm prose-li:m-0 prose-h2:mt-4 prose-h2:mb-2 prose-h3:mt-3 prose-h3:mb-2">
          <%= raw(@shownotes) %>
        </div>
      </section>
    </.page>
    """
  end
end
