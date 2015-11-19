defmodule Bouncio.UserView do
  use Bouncio.Web, :view

  def render("index.json", %{data: users}) do
    %{data: render_many(users, Bouncio.UserView, "user.json")}
  end

  def render("show.json", %{data: user}) do
    %{data: render_one(user, Bouncio.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    [handle | domain] = String.split(user.email, "@")
    masked_email = String.replace(handle, ~r/\w/, "*") <> "@" <> List.last(domain)
    %{id: user.id, type: "users", attributes: %{ "masked-email": masked_email, "email-verified": user.email_verified }, relationships: %{app: %{data: %{id: user.app_id, type: "apps"}}}}
  end
end
