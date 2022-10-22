defmodule Kapselistudio.Repo.Migrations.AddAuthors do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      add :authors, {:array, :string}, default: []
      add :show_art, :string
      # https://hexdocs.pm/ecto/Ecto.Enum.html
      # Episodic, Episodic with Seasons, Serial
      # Affects grouping and sort order (episodic = newest to oldest, serial = oldest to newest)
      add :show_type, :string, default: "episodic"
    end
  end
end
