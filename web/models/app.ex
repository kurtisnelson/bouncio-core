defmodule Bouncio.App do
  use Bouncio.Web, :model
  @internal_id "00000000-0000-0000-0000-000000000000"
  def internal_id, do: @internal_id

  schema "apps" do
    field :name, :string
    has_many :users, Bouncio.User
    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:id, name: :user_app_pkey)
  end
end
