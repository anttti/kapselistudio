defmodule KapselistudioWeb.WebsiteLive.HeaderComponent do
  use Phoenix.Component

  def header(assigns) do
    ~H"""
    <div class="flex flex-col gap-8 p-8 lg:w-80 lg:min-h-screen bg-gray-100 lg:fixed items-center lg:items-start">
      <%= live_redirect to: @home_page_url do %>
        <img src="/images/webbidevaus-logo.jpg" class="block w-64 h-64 bg-white rounded shadow" />
      <% end %>
      <h1 class="text-2xl"><%= @name %></h1>
      <p class=""><%= @description %></p>
      <p class=""><%= @author %></p>
    </div>
    """
  end
end
