defmodule Bouncio.UserController do
  use Bouncio.Web, :controller

  alias Bouncio.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", data: users)
  end

  def create(conn, %{"data" => user_data}) do
    case Repo.insert(User.changeset(%User{}, parse_payload(user_data))) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bouncio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render conn, "show.json", data: user
  end

  def update(conn, %{"id" => id, "data" => user_data}) do
    user = Repo.get!(User, id)
    case Repo.update(User.changeset(user, parse_payload(user_data))) do
      {:ok, user} ->
        render(conn, "show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bouncio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def parse_payload(data) do
    case data["id"] do
      nil ->
        changemap = %{}
      id ->
        changemap = %{"id" => id}
    end
    changemap = Map.merge(changemap, data["attributes"])
    Map.merge(changemap, %{"app_id" => data["relationships"]["app"]["data"]["id"]})
  end
end
