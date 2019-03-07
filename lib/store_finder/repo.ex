defmodule StoreFinder.Repo do
  use Ecto.Repo,
    otp_app: :store_finder,
    adapter: Ecto.Adapters.Postgres
end
