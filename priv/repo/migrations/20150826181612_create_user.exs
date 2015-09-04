defmodule Bouncer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :email, :string

      timestamps
    end
  end
end
