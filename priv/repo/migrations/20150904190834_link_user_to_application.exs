defmodule Bouncio.Repo.Migrations.LinkUserToApplication do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :app_id, references(:apps, type: :binary_id)
    end
    create unique_index(:users, [:email, :app_id], name: :users_email_app_index)
  end
end
