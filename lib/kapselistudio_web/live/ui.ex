defmodule KapselistudioWeb.UI do
  use Phoenix.Component
  use Phoenix.HTML

  def panel(assigns) do
    ~H"""
    <section class="bg-white rounded shadow border-gray-200 p-4">
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  def border(assigns) do
    ~H"""
    <section class="flex flex-col mb-8">
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
