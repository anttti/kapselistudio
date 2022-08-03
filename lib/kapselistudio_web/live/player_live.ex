defmodule KapselistudioWeb.PlayerLive do
  use KapselistudioWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= if @url do %>
      <div class="p-4 bg-gray-200 h-16 flex justify-center fixed z-50 left-0 right-0 bottom-0">
        <audio class="w-full" controls src={@url} />
      </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :url, nil), layout: false}
  end

  def handle_event("set_url", %{"url" => url}, socket) do
    {:noreply, assign(socket, :url, url)}
  end
end
