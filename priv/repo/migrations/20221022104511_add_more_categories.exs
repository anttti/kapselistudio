defmodule Kapselistudio.Repo.Migrations.AddMoreCategories do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      add :main_category_2, :string
      add :main_category_3, :string
    end

    rename table(:podcasts), :main_category, to: :main_category_1
  end
end
