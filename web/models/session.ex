defmodule Bouncio.Session do
  import MultiDef
  alias Bouncio.User

  def login(params, repo) do
    repo.get_by(User, email: String.downcase(params["username"])) |> from_password(params["password"])
  end

  mdef authenticate do
    nil, _ -> false
    user, password -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
  end

  def from_password(user, password) do
    case authenticate(user, password) do
      true -> {:ok, build_session(user)}
      _    -> :error
    end
  end

  def build_session(user) do
    %{access_token: "foo", refresh_token: "bar", expires_in: 3600, token_type: "Bearer", id_token: "", user_id: user.id}
  end
end
