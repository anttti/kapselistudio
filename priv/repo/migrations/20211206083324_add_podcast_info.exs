defmodule Kapselistudio.Repo.Migrations.AddPodcastInfo do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      add :slug, :text
      add :description, :text
      add :url, :text
      add :language, :text
      add :author, :text
      add :type, :text
      add :explicit, :boolean
      add :keywords, :text
      add :owner_name, :text
      add :owner_email, :text
      add :main_category, :text
      add :sub_category_1, :text
      add :sub_category_2, :text
      add :sub_category_3, :text
    end
  end
end
