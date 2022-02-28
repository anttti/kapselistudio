defmodule KapselistudioWeb.EpisodeLive.Show do
  use KapselistudioWeb, :live_view

  alias Phoenix.LiveView.JS
  alias Kapselistudio.Media
  alias Kapselistudio.MP3Stat

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    episode = Media.get_episode!(id)

    {:ok,
     socket
     |> assign(%{
       changeset: Media.change_episode(episode),
       shownote_preview: Earmark.as_html!(episode.shownotes)
     })
     |> allow_upload(:audio_file,
       accept: ~w(.mp3),
       max_entries: 1,
       max_file_size: 100_000_000,
       auto_upload: true,
       progress: &handle_upload_progress/3
     )}
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
    uploaded_files =
      consume_uploaded_entries(socket, :audio_file, fn %{path: path}, _entry ->
        dest =
          Path.join([:code.priv_dir(:kapselistudio), "static", "uploads", Path.basename(path)])

        IO.puts(dest)
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
      end)

    save_episode(socket, :edit_episode, episode_params)
  end

  def handle_event("publish", _params, socket) do
    change_publish_status(DateTime.now!("Etc/UTC"), "PUBLISHED", socket)
  end

  def handle_event("unpublish", _params, socket) do
    change_publish_status(nil, "DRAFT", socket)
  end

  def handle_event("delete", _params, socket) do
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

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :audio_file, ref)}
  end

  # Uploads
  defp handle_upload_progress(:audio_file, entry, socket) do
    if entry.done? do
      %{path: path, dest: dest} =
        consume_uploaded_entry(
          socket,
          entry,
          &upload_static_file(&1, entry.client_name, socket)
        )

      # TODO: Perform this parsing asynchronously
      {:ok, %{:duration => duration}} = MP3Stat.parse(dest)
      save_episode(socket, :edit_episode, %{url: path, duration: duration})

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  defp upload_static_file(%{path: path}, client_name, socket) do
    # Copy the uploaded file to disk
    filename = "#{Ecto.UUID.generate()}_#{client_name}"
    # dest = Path.join("priv/static/audio-files", "#{Path.basename(path)}")
    dest = Path.join("priv/static/audio-files", "#{filename}")
    File.cp!(path, dest)
    %{path: Routes.static_path(socket, "/audio-files/#{filename}"), dest: dest}
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

  defp save_episode(socket, :edit_episode, episode_params) do
    case Media.update_episode(socket.assigns.episode, episode_params) do
      {:ok, _episode} ->
        {:noreply, put_flash(socket, :info, "Muutokset tallennettu")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
