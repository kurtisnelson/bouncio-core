defmodule Bouncer.UserView do
  use Bouncer.Web, :view

  def render("index.json", %{data: users}) do
    %{data: render_many(users, Bouncer.UserView, "user.json")}
  end

  def render("show.json", %{data: user}) do
    %{data: render_one(user, Bouncer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, type: "users", attributes: %{ application_id: user.application_id, email: user.email }}
  end
end
