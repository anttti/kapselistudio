defmodule KapselistudioWeb.WebsiteLive.Components do
  import Phoenix.LiveView.Helpers

  def page(assigns) do
    ~H"""
    <div class="body">
      <div class="sidebar bg-gray-100">
        <div class="p-8 flex flex-col gap-8 bg-gray-100">
          <%= live_redirect(
            to:
              KapselistudioWeb.SubdomainRouter.Helpers.website_show_podcast_path(
                KapselistudioWeb.Endpoint,
                :show_podcast
              )
          ) do %>
            <img src="/images/webbidevaus-logo.jpg" class="block w-64 h-64 bg-white rounded shadow" />
          <% end %>
          <h1 class="text-2xl"><%= @name %></h1>
          <p class=""><%= @description %></p>
          <p class=""><%= @author %></p>
        </div>
      </div>
      <div class="content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def play_button(assigns) do
    ~H"""
    <button
      class="text-sm py-2 play-button flex gap-4"
      data-url={@url}
      data-title={@title}
      data-number={@number}
    >
      <svg viewBox="0 0 39 46" class="w-3">
        <path
          fill="currentColor"
          d="M-2.5034e-06 0.483337L39 23L-2.31961e-06 45.5167L-2.5034e-06 0.483337Z"
        />
      </svg>
      Kuuntele
    </button>
    """
  end

  def show_notes_button(assigns) do
    ~H"""
    <button class="text-sm px-4 py-2 play-button flex gap-4">
      <svg viewBox="0 0 63 15" class="w-4">
        <circle cx="7.5" cy="7.5" r="7.5" fill="currentColor" />
        <circle cx="31.5" cy="7.5" r="7.5" fill="currentColor" />
        <circle cx="55.5" cy="7.5" r="7.5" fill="currentColor" />
      </svg>
      Lue lisää
    </button>
    """
  end
end
