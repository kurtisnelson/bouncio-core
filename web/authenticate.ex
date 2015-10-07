defmodule Bouncio.Authenticate do
  alias Plug.Conn

  @behaviour Plug

  def init([]), do: []

  def call(conn, []) do
    case authenticate(conn) do
      {:ok, user} ->
        conn
        |> Conn.assign(:current_user, user)
      :error ->
        conn
        |> Conn.send_resp(401, "")
        |> Conn.halt
    end
  end

  defp authenticate(conn) do
    header = Conn.get_req_header(conn, "authorization")
    token = parse_header(header)

    case Bouncio.Session.from_bearer(token) do
      :error ->
        :error
      {:ok, session} ->
        {:ok, session.user_id}
    end
  end

  defp parse_header(["Bearer " <> token]), do: token
  defp parse_header(_), do: ""
end
