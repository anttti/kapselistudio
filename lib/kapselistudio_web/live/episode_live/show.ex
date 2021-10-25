defmodule KapselistudioWeb.EpisodeLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    episode = Media.get_episode!(id)

    {:ok,
     assign(socket, %{
       changeset: Media.change_episode(episode),
       shownote_preview: Earmark.as_html!(episode.shownotes)
     })}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Jakson tiedot")
    |> assign(:episode, Media.get_episode!(id))
  end

  defp apply_action(socket, :edit_episode, %{"episode_id" => episode_id}) do
    socket
    |> assign(:page_title, "Muokkaa jaksoa")
    |> assign(:episode, Media.get_episode!(episode_id))
  end

  @impl true
  def handle_event("validate", %{"episode" => episode_params}, socket) do
    changeset =
      socket.assigns.episode
      |> Media.change_episode(episode_params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket, %{
       changeset: changeset,
       shownote_preview: Earmark.as_html!(Map.get(episode_params, "shownotes"))
     })}
  end

  def handle_event("save", %{"episode" => episode_params}, socket) do
    save_episode(socket, :edit_episode, episode_params)
  end

  def handle_event("publish", _params, socket) do
    case Media.update_episode(socket.assigns.episode, %{
           "published_at" => DateTime.now!("Etc/UTC"),
           "status" => "PUBLISHED"
         }) do
      {:ok, episode} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jakso julkaistu")
         |> assign(%{
           episode: episode
         })}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("unpublish", _params, socket) do
    case Media.update_episode(socket.assigns.episode, %{
           "published_at" => nil,
           "status" => "DRAFT"
         }) do
      {:ok, episode} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jakson julkaisu peruttu")
         |> assign(%{
           episode: episode
         })}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_episode(socket, :edit_episode, episode_params) do
    case Media.update_episode(socket.assigns.episode, episode_params) do
      {:ok, _episode} ->
        {:noreply, put_flash(socket, :info, "Muutokset tallennettu")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  # defp save_episode(socket, :new_episode, episode_params) do
  #   case Media.create_episode(episode_params) do
  #     {:ok, _episode} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Episode created successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end
end
