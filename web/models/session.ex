defmodule Bouncio.Session do
  import MultiDef
  alias Bouncio.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["username"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, new_session(user)}
      _    -> :error
    end
  end

  mdef authenticate do
    nil, _ -> false
    user, password -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
  end

  def new_session(user) do
    %{user_id: user.id}
  end
end
