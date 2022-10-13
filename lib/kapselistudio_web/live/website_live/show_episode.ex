defmodule KapselistudioWeb.WebsiteLive.ShowEpisode do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(%{"episode_number" => episode_number}, _session, socket) do
    with %URI{host: host} = socket.host_uri,
         subdomain = Kapselistudio.Origin.get_subdomain(host),
         podcast = Media.get_podcast_for_slug!(subdomain),
         episode <- Media.get_published_episode!(podcast.id, episode_number),
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
      <section class="p-8 flex flex-col gap-2">
        <h1 class="text-xl md:text-2xl font-bold text-gray-900 break-all">
          <%= @episode.number %>: <%= @episode.title %>
        </h1>

        <.play_button
          class="text-primary"
          url={@episode.url}
          title={@episode.title}
          number={@episode.number}
        >
          Kuuntele jakso
        </.play_button>

        <div class="prose prose-sm prose-li:m-0 prose-h2:mt-4 prose-h2:mb-2 prose-h3:mt-3 prose-h3:mb-2">
          <%= raw(@shownotes) %>
        </div>
      </section>
    </.page>
    """
  end
end
