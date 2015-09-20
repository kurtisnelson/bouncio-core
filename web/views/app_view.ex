defmodule Bouncio.AppView do
  use Bouncio.Web, :view

  def render("index.json", %{data: apps}) do
    %{data: render_many(apps, Bouncio.AppView, "app.json")}
  end

  def render("show.json", %{data: app}) do
    %{data: render_one(app, Bouncio.AppView, "app.json")}
  end

  def render("app.json", %{app: app}) do
    %{id: app.id, type: "apps", attributes: %{ name: app.name }}
  end
end
