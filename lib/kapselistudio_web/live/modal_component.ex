defmodule KapselistudioWeb.ModalComponent do
  use KapselistudioWeb, :live_component

  @impl true
  @spec render(atom | %{:opts => any, optional(any) => any}) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    {:title, title} =
      Enum.find(assigns.opts, fn {key, _val} ->
        key == :title
      end)

    ~H"""
    <div
      id={@id}
      class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>

      <div class="phx-modal-content rounded shadow-lg bg-white">
        <div class="bg-gray-50 rounded-t border-b border-gray-200">
          <h2 class="px-4 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"><%= title %></h2>
          <%= live_patch raw("&times;"), to: @return_to, class: "absolute right-[15px] top-[6px] text-gray-400 text-2xl" %>
        </div>
        <div class="p-4">
          <%= live_component @component, @opts %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
