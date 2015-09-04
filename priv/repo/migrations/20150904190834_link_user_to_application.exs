defmodule Bouncer.Repo.Migrations.LinkUserToApplication do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :application_id, references(:applications, type: :binary_id)
    end
    create unique_index(:users, [:email, :application_id], name: :users_email_app_index)
  end
end
