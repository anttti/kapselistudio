defmodule KapselistudioWeb.TagLive.Index do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media
  alias Kapselistudio.Media.Tag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tags, list_tags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, Media.get_tag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Media.get_tag!(id)
    {:ok, _} = Media.delete_tag(tag)

    {:noreply, assign(socket, :tags, list_tags())}
  end

  defp list_tags do
    Media.list_tags()
  end
end
