defmodule Bouncer.User do
  use Bouncer.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    belongs_to :application, Bouncer.Application
    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w(id)

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
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email, name: :users_email_app_index)
  end
end
