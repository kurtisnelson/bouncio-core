defmodule Bouncer.Application do
  use Bouncer.Web, :model

  schema "applications" do
    field :name, :string
    has_many :users, Bouncer.User
    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:id, name: :application_pkey)
  end
end
