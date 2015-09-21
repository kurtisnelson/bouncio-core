defmodule Bouncio.SessionController do
  use Bouncio.Web, :controller

  alias Bouncio.Session
  plug :secure_cache_headers

  def create(conn, session_params) do
    case Session.login(session_params, Repo) do
      {:ok, session} ->
        conn
        |> fetch_session
        |> put_session(:current_user, session.user_id)
        |> put_status(:created)
        |> render "new.json", session: session
      _ ->
        conn
        |> fetch_session
        |> put_session(:current_user, nil)
        |> put_status(:bad_request)
        |> json %{error: "invalid_request"}
    end
  end

  def show(conn) do

  end

  def delete(conn) do

  end

  defp secure_cache_headers(conn, _) do
    Plug.Conn.put_resp_header(conn, "cache-control", "no-store, private")
    Plug.Conn.put_resp_header(conn, "pragma", "no-cache")
  end
end
