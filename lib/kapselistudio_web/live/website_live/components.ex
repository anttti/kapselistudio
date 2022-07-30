defmodule KapselistudioWeb.WebsiteLive.Components do
  import Phoenix.HTML
  import Phoenix.LiveView.Helpers

  def podcast(assigns) do
    ~H"""
    <section class="flex-1 p-8 lg:ml-80">
      <ol class="divide-y divide-gray-300">
        <%= for episode <- @podcast.episodes do %>
          <li class="pb-4">
            <div class="flex px-6 pt-4 pb-2 text-sm font-medium text-gray-900">
              <div class="flex-1">
                <a phx-click="show-episode" phx-value-episode={episode.id}>
                  <%= Integer.to_string(episode.number) <> ". " <> episode.title %>
                </a>
              </div>
              <div class="w-48 text-right text-gray-400">
                <%= KapselistudioWeb.DateHelpers.format_date(episode.published_at) %>
              </div>
            </div>
            <p class="px-6 text-sm text-gray-800"><%= episode.description %></p>
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

      <audio class="w-full" controls src={@url} />

      <div class="prose prose-sm prose-li:m-0 prose-h2:mt-4 prose-h2:mb-2 prose-h3:mt-3 prose-h3:mb-2">
        <%= raw(@shownotes) %>
      </div>
    </section>
    """
  end
end
