defmodule Kapselistudio.Repo.Migrations.AddPodcastFields do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      add :copyright, :text
      add :image, :text
    end

    alter table(:episodes) do
      add :image, :text
      add :explicit, :boolean
      add :episode_type, :text
      add :author, :text
      add :filesize, :integer
    end
  end
end
