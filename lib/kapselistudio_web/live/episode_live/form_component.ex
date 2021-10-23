defmodule KapselistudioWeb.EpisodeLive.FormComponent do
  use KapselistudioWeb, :live_component

  alias Kapselistudio.Media

  @impl true
  def update(%{episode: episode} = assigns, socket) do
    changeset = Media.change_episode(episode)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"episode" => episode_params}, socket) do
    changeset =
      socket.assigns.episode
      |> Media.change_episode(episode_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"episode" => episode_params}, socket) do
    save_episode(socket, socket.assigns.action, episode_params)
  end

  defp save_episode(socket, :edit_episode, episode_params) do
    case Media.update_episode(socket.assigns.episode, episode_params) do
      {:ok, _episode} ->
        {:noreply,
         socket
         |> put_flash(:info, "Episode updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_episode(socket, :new_episode, episode_params) do
    case Media.create_episode(episode_params) do
      {:ok, _episode} ->
        {:noreply,
         socket
         |> put_flash(:info, "Episode created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
