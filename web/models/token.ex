defmodule Token do
  def generate(n \\ 16) do
    :crypto.strong_rand_bytes(n)
    |> Base.encode16
    |> String.downcase
  end
end
