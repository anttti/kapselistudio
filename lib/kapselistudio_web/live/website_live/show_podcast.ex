defmodule KapselistudioWeb.WebsiteLive.ShowPodcast do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    # @TODO: Move to Media
    limit = 11
    podcast = Media.get_podcast_for_slug_with_episodes!(subdomain, 0, limit)
    episodes = Enum.take(podcast.episodes, limit - 1)
    latest_episode = List.first(episodes)
    has_more? = Enum.count(podcast.episodes) == limit

    {:ok,
     socket
     |> assign(:podcast, podcast)
     |> assign(:episodes, episodes)
     |> assign(:has_more?, has_more?)
     |> assign(:latest_episode, latest_episode)
     |> assign(:rest_episodes, Enum.drop(episodes, 1))
     |> assign(
       :latest_episode_title,
       episode_title(latest_episode)
     )}
  end

  defp episode_title(%{number: number, title: title}) do
    Integer.to_string(number) <> ". " <> title
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.page name={@podcast.name} description={@podcast.description} author={@podcast.author}>
      <section class="flex flex-col gap-4 md:gap-8 p-4 md:p-8">
        <div class="flex flex-col gap-2 md:gap-4 p-4 md:p-8 bg-primary text-white rounded-xl max-w-4xl mx-auto">
          <h2 class="uppercase font-bold text-sm tracking-widest">Uusin jakso</h2>
          <div class="flex gap-4 md:gap-8">
            <div class="text-4xl md:text-6xl font-extrabold mt-[-2px] text-primary-dark">
              <%= @latest_episode.number %>
            </div>
            <div class="flex flex-col gap-2">
              <h1 class="text-xl font-bold">
                <%= live_redirect(@latest_episode.title,
                  to:
                    KapselistudioWeb.SubdomainRouter.Helpers.website_show_episode_path(
                      KapselistudioWeb.Endpoint,
                      :show_episode,
                      @latest_episode.number
                    )
                ) %>
              </h1>
              <p class="text-sm"><%= @latest_episode.description %></p>
              <div class="flex gap-2">
                <.play_button
                  url={@latest_episode.url}
                  title={@latest_episode.title}
                  number={@latest_episode.number}
                >
                  Kuuntele jakso
                </.play_button>
                <.show_notes_button number={@latest_episode.number} />
              </div>
            </div>
          </div>
        </div>

        <div class="max-w-4xl mx-auto px-8">
          <div class="flex items-center">
            <hr class="h-[1px] bg-gray-200 flex-1" />
            <h2 class="px-4 uppercase font-bold text-sm tracking-widest">Aiemmat jaksot</h2>
            <hr class="h-[1px] bg-gray-200 flex-1" />
          </div>
          <ol class="divide-y divide-gray-200">
            <%= for episode <- @rest_episodes do %>
              <li class="py-4 flex flex-col gap-2">
                <div class="flex text-md font-medium text-gray-900">
                  <div class="flex-1">
                    <%= live_redirect(episode_title(episode),
                      to:
                        KapselistudioWeb.SubdomainRouter.Helpers.website_show_episode_path(
                          KapselistudioWeb.Endpoint,
                          :show_episode,
                          episode.number
                        )
                    ) %>
                  </div>
                  <div class="text-right text-gray-400">
                    <%= KapselistudioWeb.DateHelpers.format_date(episode.published_at) %>
                  </div>
                </div>
                <p class="text-sm text-gray-800"><%= episode.description %></p>
                <div class="flex gap-2">
                  <.play_button url={episode.url} title={episode.title} number={episode.number}>
                    Kuuntele jakso
                  </.play_button>
                  <.show_notes_button number={episode.number} />
                </div>
              </li>
            <% end %>
          </ol>

          <%= if @has_more? do %>
            <%= live_redirect("Näytä lisää",
              to:
                KapselistudioWeb.SubdomainRouter.Helpers.website_show_all_path(
                  KapselistudioWeb.Endpoint,
                  :show_all_episodes
                )
            ) %>
          <% end %>
        </div>
      </section>
    </.page>
    """
  end
end
