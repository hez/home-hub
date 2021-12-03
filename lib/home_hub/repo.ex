defmodule HomeHub.Repo do
  use Ecto.Repo,
    otp_app: :home_hub,
    adapter: Ecto.Adapters.SQLite3
end
