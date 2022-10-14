defmodule KapselistudioWeb.LayoutView do
  use KapselistudioWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def meta_tags(attrs_list) do
    Enum.map(attrs_list, &meta_tag/1)
  end

  def meta_tag(attrs) do
    tag(:meta, Enum.into(attrs, []))
  end

  def meta_image(image_url) do
    """
    <meta property="og:image" content="#{image_url}" />
    <meta property="twitter:image" content="#{image_url}" />
    """
  end
end
