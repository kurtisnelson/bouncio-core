defmodule Bouncer.AppView do
  use Bouncer.Web, :view

  def render("index.json", %{data: apps}) do
    %{data: render_many(apps, Bouncer.AppView, "app.json")}
  end

  def render("show.json", %{data: app}) do
    %{data: render_one(app, Bouncer.AppView, "app.json")}
  end

  def render("app.json", %{app: app}) do
    %{id: app.id, type: "apps", attributes: %{ name: app.name }}
  end
end
