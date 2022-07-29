defmodule KapselistudioWeb.AdminLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Accounts
  import KapselistudioWeb.UI

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user_registration(user)

    {:ok, socket |> assign(:user, user) |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:user, user)
         |> put_flash(:info, "User updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
