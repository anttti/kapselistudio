defmodule KapselistudioWeb.WebsiteLive.ShowAll do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.Components

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    podcast = Media.get_podcast_for_slug_with_all_episodes!(subdomain)

    {:ok,
     socket
     |> assign(:podcast, podcast)
     |> assign(:episodes, podcast.episodes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row">
      <.sidebar name={@podcast.name} description={@podcast.description} author={@podcast.author} />
      <section class="flex-1 p-8 flex flex-col gap-4 lg:ml-80">
        <h2>Aiemmat jaksot</h2>
        <ol>
          <%= for episode <- @episodes do %>
            <li class="py-2">
              <div class="flex text-sm font-medium text-gray-900">
                <div class="flex-1">
                  <%= live_patch(Integer.to_string(episode.number) <> ". " <> episode.title,
                    to:
                      KapselistudioWeb.SubdomainRouter.Helpers.website_show_path(
                        KapselistudioWeb.Endpoint,
                        :show_episode,
                        episode.id
                      )
                  ) %>
                </div>
                <div class="w-48 text-right text-gray-400">
                  <%= KapselistudioWeb.DateHelpers.format_date(episode.published_at) %>
                </div>
              </div>
            </li>
          <% end %>
        </ol>
      </section>
    </div>
    """
  end
end
