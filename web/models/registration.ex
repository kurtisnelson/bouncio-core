defmodule Bouncer.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    changeset
    |> put_change(:crypted_password, changeset.params["password"] |> Comeonin.Bcrypt.hashpwsalt)
    |> repo.insert()
  end
end
