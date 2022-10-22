defmodule KapselistudioWeb.PodcastLive.FormComponent do
  use KapselistudioWeb, :live_component

  alias Kapselistudio.Media

  @impl true
  def update(%{podcast: podcast} = assigns, socket) do
    changeset = Media.change_podcast(podcast)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"podcast" => podcast_params}, socket) do
    podcast_params = ensure_authors_is_list(podcast_params)

    changeset =
      socket.assigns.podcast
      |> Media.change_podcast(podcast_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"podcast" => podcast_params}, socket) do
    save_podcast(socket, socket.assigns.action, podcast_params)
  end

  defp save_podcast(socket, :edit, podcast_params) do
    podcast_params = ensure_authors_is_list(podcast_params)

    case Media.update_podcast(socket.assigns.podcast, podcast_params) do
      {:ok, _podcast} ->
        {:noreply,
         socket
         |> put_flash(:info, "Podcast updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_podcast(socket, :new, podcast_params) do
    podcast_params = ensure_authors_is_list(podcast_params)

    case Media.create_podcast(podcast_params) do
      {:ok, _podcast} ->
        {:noreply,
         socket
         |> put_flash(:info, "Podcast created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ensure_authors_is_list(%{"authors" => authors} = params) when is_list(authors) do
    params
  end

  defp ensure_authors_is_list(params) do
    Map.put(params, "authors", [Map.get(params, "authors")])
  end
end
