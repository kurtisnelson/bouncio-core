defmodule Bouncer.Application do
  use Bouncer.Web, :model

  schema "applications" do
    field :name, :string
    has_many :users, Bouncer.User
  end
end
