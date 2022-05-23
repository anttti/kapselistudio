defmodule KapselistudioWeb.EpisodeLive.Show do
  use KapselistudioWeb, :live_view

  alias Phoenix.LiveView.JS
  alias Kapselistudio.Media
  alias Kapselistudio.Media.Episode
  alias Kapselistudio.MP3Stat

  @impl Phoenix.LiveView
  def mount(%{"id" => id, "podcast_id" => podcast_id}, _session, socket) do
    episode = Media.get_episode!(id)

    mount_reply(socket, %{
      changeset: Media.change_episode(episode),
      shownote_preview: Earmark.as_html!(episode.shownotes),
      podcast_id: podcast_id
    })
  end

  def mount(%{"podcast_id" => podcast_id}, _session, socket) do
    mount_reply(socket, %{
      changeset: Media.new_episode() |> Media.change_episode(),
      shownote_preview: "",
      podcast_id: podcast_id
    })
  end

  defp mount_reply(socket, changes) do
    {:ok,
     socket
     |> assign(changes)
     |> allow_upload(:audio_file,
       accept: ~w(.mp3),
       max_entries: 1,
       max_file_size: 100_000_000
       # TODO: Show upload progress
       #  progress: &handle_upload_progress/3
     )}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Muokkaa jaksoa")
    |> assign(:episode, Media.get_episode!(id))
  end

  defp apply_action(socket, :new, _) do
    socket
    |> assign(:page_title, "Uusi jakso")
    |> assign(:episode, %Episode{})
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

  @impl true
  def handle_event("publish", _params, socket) do
    # TODO: Validate that the episode has a URL and a duration
    change_publish_status(DateTime.now!("Etc/UTC"), "PUBLISHED", socket)
  end

  @impl true
  def handle_event("unpublish", _params, socket) do
    change_publish_status(nil, "DRAFT", socket)
  end

  @impl true
  def handle_event("delete", _params, socket) do
    # TODO: Delete the audio file if it exists
    {:ok, _} = Media.delete_episode(socket.assigns.episode)

    {:noreply,
     socket
     |> put_flash(:info, "Jakso poistettu")
     |> push_redirect(
       to:
         Routes.podcast_show_path(
           KapselistudioWeb.Endpoint,
           :show,
           socket.assigns.episode.podcast
         )
     )}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :audio_file, ref)}
  end

  @impl true
  def handle_event("delete_audio_file", _params, socket) do
    # TODO: Delete the audio file if it exists
    changes = %{"url" => nil, "duration" => nil}
    save_episode(socket, socket.assigns.episode, :edit_episode, changes)
  end

  @impl true
  def handle_event("save", %{"episode" => episode_params}, socket) do
    audio_files =
      consume_uploaded_entries(socket, :audio_file, fn file, entry ->
        filename = "#{Ecto.UUID.generate()}_#{entry.client_name}"
        dest = Path.join([:code.priv_dir(:kapselistudio), "static", "audio-files", filename])
        File.cp!(file.path, dest)
        {:ok, %{:duration => duration}} = MP3Stat.parse(dest)
        path = "/audio-files/" <> filename
        Routes.static_path(socket, path)

        %{:path => path, :duration => duration}
      end)

    %{path: url, duration: duration} = get_file_info(Enum.at(audio_files, 0))

    changes =
      episode_params
      |> add_param("url", url)
      |> add_param("duration", duration)

    if socket.assigns.episode.id do
      save_episode(socket, socket.assigns.episode, :edit_episode, changes)
    else
      save_episode(
        socket,
        %Episode{},
        :new_episode,
        changes
        |> Map.put("podcast_id", socket.assigns.podcast_id)
      )
    end
  end

  def change_publish_status(published_at, status, socket) do
    case Media.update_episode(socket.assigns.episode, %{
           "published_at" => published_at,
           "status" => status
         }) do
      {:ok, episode} ->
        {:noreply,
         socket
         |> put_flash(:info, "Muutokset tallennettu")
         |> assign(%{
           episode: episode
         })}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_episode(socket, _, :new_episode, episode_params) do
    case Media.create_episode(episode_params) do
      {:ok, episode} ->
        redirect_to_episode(socket, "Jakso luotu", episode)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_episode(socket, episode, :edit_episode, episode_params) do
    case Media.update_episode(episode, episode_params) do
      {:ok, episode} ->
        redirect_to_episode(socket, "Muutokset tallennettu", episode)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp redirect_to_episode(socket, info, episode) do
    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_redirect(
       to:
         Routes.episode_show_path(
           KapselistudioWeb.Endpoint,
           :edit,
           episode.podcast_id,
           episode
         )
     )}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  defp add_param(params, _, nil), do: params
  defp add_param(params, key, val), do: Map.put(params, key, val)

  defp get_file_info(nil), do: %{path: nil, duration: nil}
  defp get_file_info(file), do: file
end
