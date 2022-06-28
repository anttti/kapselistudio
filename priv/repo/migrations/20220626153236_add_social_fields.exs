defmodule Kapselistudio.Repo.Migrations.AddSocialFields do
  use Ecto.Migration

  def change do
    create table(:podcast_links) do
      add :url, :text
      add :title, :text
      add :icon, :text
      add :podcast_id, references(:podcasts)
    end
  end
end
