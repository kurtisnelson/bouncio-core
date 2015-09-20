defmodule Bouncio.SessionController do
  use Bouncio.Web, :controller

  def create(conn, %{"session" => session_params}) do
    case Bouncio.Session.login(session_params, Repo) do
      {:ok, session} ->
        conn
        |> put_session(:current_user, session.user_id)
        |> put_status(:created)
        |> render("show.json", session: session)
      :error ->
        conn
        |> put_status(:unauthorized)
    end
  end

  def show(conn) do

  end

  def delete(conn) do

  end
end
