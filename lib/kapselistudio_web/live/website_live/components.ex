defmodule KapselistudioWeb.WebsiteLive.Components do
  import Phoenix.LiveView.Helpers

  def page(assigns) do
    ~H"""
    <div class="flex flex-col lg:flex-row">
      <div class="flex flex-col gap-8 p-8 lg:w-80 lg:min-h-screen bg-gray-100 lg:fixed items-center lg:items-start">
        <%= live_patch("Etusivu",
          to:
            KapselistudioWeb.SubdomainRouter.Helpers.website_show_podcast_path(
              KapselistudioWeb.Endpoint,
              :show_podcast
            )
        ) %>
        <a href="/" phx-click="show-podcast" onclick="return false">
          <img src="/images/webbidevaus-logo.jpg" class="block w-64 h-64 bg-white rounded shadow" />
        </a>
        <h1 class="text-2xl"><%= @name %></h1>
        <p class=""><%= @description %></p>
        <p class=""><%= @author %></p>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
