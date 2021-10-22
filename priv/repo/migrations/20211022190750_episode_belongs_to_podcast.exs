defmodule Kapselistudio.Repo.Migrations.EpisodeBelongsToPodcast do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add :podcast_id, references(:podcasts)
    end
  end
end
