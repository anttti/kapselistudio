defmodule KapselistudioWeb.AdminLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Accounts
  import KapselistudioWeb.UI

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user_registration(user)
    password_changeset = Accounts.admin_change_user_password(user)

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:changeset, changeset)
     |> assign(:password_changeset, password_changeset)}
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
  def handle_event("password_validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.admin_change_user_password(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :password_changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:user, user)
         |> put_flash(:info, "Käyttäjän tiedot päivitetty")
         |> push_redirect(
           to:
             Routes.admin_index_path(
               KapselistudioWeb.Endpoint,
               :index
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("password_save", %{"user" => user_params}, socket) do
    IO.inspect("SAVING!")
    IO.inspect(socket.assigns.user)
    IO.inspect(user_params)

    case Accounts.admin_update_user_password(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:user, user)
         |> put_flash(:info, "Käyttäjän tiedot päivitetty")
         |> push_redirect(
           to:
             Routes.admin_index_path(
               KapselistudioWeb.Endpoint,
               :index
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
