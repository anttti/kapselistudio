defmodule Kapselistudio.Media.Podcast do
  use Ecto.Schema
  import Ecto.Changeset

  schema "podcasts" do
    field :name, :string
    has_many :episodes, Kapselistudio.Media.Episode

    timestamps()
  end

  @doc false
  def changeset(podcast, attrs) do
    podcast
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
