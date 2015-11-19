defmodule Bouncio.Repo.Migrations.AddVerificationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email_verified, :timestamp, default: nil
    end
  end
end
