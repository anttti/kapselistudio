defmodule KapselistudioWeb.WebsiteLive.ShowPodcast do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

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
      <section class="flex flex-col gap-4 flex-1 px-8 pt-8 pb-24 lg:ml-80">
        <div class="flex flex-col gap-2 p-4 bg-gray-700 text-white">
          <h2>Uusin jakso</h2>
          <h1>
            <%= @latest_episode_title %>
          </h1>
          <p class="text-sm"><%= @latest_episode.description %></p>
          <button
            class="text-sm border border-gray-400 px-4 py-2 play-button"
            data-url={@latest_episode.url}
            data-title={@latest_episode.title}
            data-number={@latest_episode.number}
          >
            Kuuntele jakso
          </button>
        </div>
        <h2>Aiemmat jaksot</h2>
        <ol class="divide-y divide-gray-300">
          <%= for episode <- @rest_episodes do %>
            <li class="py-4 flex flex-col gap-2">
              <div class="flex text-sm font-medium text-gray-900">
                <div class="flex-1">
                  <%= live_patch(episode_title(episode),
                    to:
                      KapselistudioWeb.SubdomainRouter.Helpers.website_show_episode_path(
                        KapselistudioWeb.Endpoint,
                        :show_episode,
                        episode.number
                      )
                  ) %>
                </div>
                <div class="w-48 text-right text-gray-400">
                  <%= KapselistudioWeb.DateHelpers.format_date(episode.published_at) %>
                </div>
              </div>
              <p class="text-sm text-gray-800"><%= episode.description %></p>
              <button
                class="text-sm border border-gray-400 px-4 py-2 play-button"
                data-url={episode.url}
                data-title={episode.title}
                data-number={episode.number}
              >
                Kuuntele jakso
              </button>
            </li>
          <% end %>
        </ol>

        <%= if @has_more? do %>
          <%= live_patch("Näytä lisää",
            to:
              KapselistudioWeb.SubdomainRouter.Helpers.website_show_all_path(
                KapselistudioWeb.Endpoint,
                :show_all_episodes
              )
          ) %>
        <% end %>
      </section>
    </.page>
    """
  end
end
