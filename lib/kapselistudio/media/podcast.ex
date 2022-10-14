defmodule Kapselistudio.Media.Podcast do
  use Ecto.Schema
  import Ecto.Changeset

  schema "podcasts" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :url, :string
    field :type, :string
    field :keywords, :string
    field :owner_name, :string
    field :owner_email, :string
    field :main_category, :string
    field :sub_category_1, :string
    field :sub_category_2, :string
    field :sub_category_3, :string
    field :explicit, :boolean
    field :copyright, :string
    field :image, :string
    has_many :episodes, Kapselistudio.Media.Episode

    timestamps()
  end

  @doc false
  def changeset(podcast, attrs) do
    podcast
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :url,
      :type,
      :keywords,
      :owner_name,
      :owner_email,
      :main_category,
      :sub_category_1,
      :sub_category_2,
      :sub_category_3,
      :explicit,
      :copyright,
      :image
    ])
    |> validate_required([
      :name,
      :slug,
      :url,
      :type,
      :owner_name,
      :owner_email,
      :explicit
    ])
  end
end
