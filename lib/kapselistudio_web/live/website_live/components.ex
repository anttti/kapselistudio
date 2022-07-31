defmodule KapselistudioWeb.WebsiteLive.Components do
  import Phoenix.HTML
  import Phoenix.LiveView.Helpers

  def podcast(assigns) do
    ~H"""
    <section class="flex-1 p-8 lg:ml-80">
      <ol class="divide-y divide-gray-300">
        <%= for episode <- @podcast.episodes do %>
          <li class="py-4 px-6 flex flex-col gap-2">
            <div class="flex text-sm font-medium text-gray-900">
              <div class="flex-1">
                <a phx-capture-click="show-episode" phx-value-episode={episode.id}>
                  <%= Integer.to_string(episode.number) <> ". " <> episode.title %>
                </a>
              </div>
              <div class="w-48 text-right text-gray-400">
                <%= KapselistudioWeb.DateHelpers.format_date(episode.published_at) %>
              </div>
            </div>
            <p class="text-sm text-gray-800"><%= episode.description %></p>
            <button
              class="text-sm border border-gray-400 px-4 py-2"
              phx-click="play-episode"
              phx-value-url={episode.url}
            >
              Kuuntele jakso
            </button>
          </li>
        <% end %>
      </ol>
    </section>
    """
  end

  def episode(assigns) do
    ~H"""
    <section class="flex-1 p-8 flex flex-col gap-8 lg:ml-80">
      <h1 class="text-3xl font-medium text-gray-900">
        <%= @title %>
      </h1>

      <button phx-click="play-episode" phx-value-url={@url}>
        Toista <%= @url %>
      </button>

      <div class="prose prose-sm prose-li:m-0 prose-h2:mt-4 prose-h2:mb-2 prose-h3:mt-3 prose-h3:mb-2">
        <%= raw(@shownotes) %>
      </div>
    </section>
    """
  end
end
