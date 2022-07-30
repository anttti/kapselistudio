defmodule KapselistudioWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `KapselistudioWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal KapselistudioWeb.PodcastLive.FormComponent,
        id: @podcast.id || :new,
        action: @live_action,
        podcast: @podcast,
        return_to: Routes.podcast_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(KapselistudioWeb.ModalComponent, modal_opts)
  end

  def link(%{navigate: _to} = assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <a href={@navigate} data-phx-link="redirect" data-phx-link-state="push" class={@class}>
      <%= render_slot(@inner_block) %>
    </a>
    """
  end
end
