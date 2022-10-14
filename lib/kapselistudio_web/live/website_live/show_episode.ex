defmodule KapselistudioWeb.WebsiteLive.ShowEpisode do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components
  import Phoenix.HTML

  @impl true
  def mount(%{"episode_number" => episode_number}, _session, socket) do
    with %URI{host: host} = socket.host_uri,
         subdomain = Kapselistudio.Origin.get_subdomain(host),
         podcast = Media.get_podcast_for_slug!(subdomain),
         episode <- Media.get_published_episode!(podcast.id, episode_number),
         shownotes <- Earmark.as_html!(episode.shownotes),
         title = "#{episode_number}: #{episode.title} | #{podcast.name}",
         url = "#{podcast.url}/#{episode_number}",
         # TODO: Meta tags should be rendered as raw as otherwise ampersands get encoded and url does not work properly
         image_url =
           "https://og-webbidevaus.vercel.app/**Jakso%20#{episode_number}**:%20#{episode.title}?theme=light&md=1&fontSize=100px",
         meta_attrs = [
           %{name: "title", content: title},
           %{name: "description", content: podcast.description},
           %{name: "keywords", content: podcast.keywords},
           %{property: "og:title", content: title},
           %{property: "og:description", content: podcast.description},
           %{property: "og:url", content: url},
           %{property: "og:image", content: image_url},
           %{property: "twitter:title", content: title},
           %{property: "twitter:description", content: podcast.description},
           %{property: "twitter:url", content: url},
           %{property: "twitter:image", content: image_url}
         ] do
      {:ok,
       socket
       |> assign(:meta_attrs, meta_attrs)
       |> assign(:page_title, title)
       |> assign(:podcast, podcast)
       |> assign(:episode, episode)
       |> assign(:shownotes, shownotes)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.page name={@podcast.name} description={@podcast.description} owner_name={@podcast.owner_name}>
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
