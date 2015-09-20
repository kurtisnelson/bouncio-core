defmodule Bouncio.AppController do
  use Bouncio.Web, :controller

  alias Bouncio.App
  alias Ecto.Changeset

  def index(conn, _params) do
    apps = Repo.all(App)
    render(conn, "index.json", data: apps)
  end

  def show(conn, %{"id" => id}) do
    app = Repo.get!(App, id)
    render conn, "show.json", data: app
  end
end
