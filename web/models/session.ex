defmodule Blog.Session do
  import MultiDef
  alias Blog.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  mdef authenticate do
    nil, _ -> false
    user, password -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
  end
end
