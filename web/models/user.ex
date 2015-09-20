defmodule Bouncio.User do
  use Bouncio.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    belongs_to :app, Bouncio.App
    timestamps
  end

  @required_fields ~w(app_id email)
  @optional_fields ~w(password id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:password, min: 8)
    |> foreign_key_constraint(:app_id)
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email, name: :users_email_app_index)
    |> update_password_hash
  end

  def update_password_hash(changeset) do
    case {changeset.params["password"], changeset.model.crypted_password} do
      {nil, nil} ->
        add_error(changeset, :password, "empty")
      {nil, _} ->
        changeset
      {password, _} ->
        put_change(changeset, :crypted_password, hashpwsalt(password))
    end
  end
end
