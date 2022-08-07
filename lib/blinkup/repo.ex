defmodule Blinkup.Repo do
  use Ecto.Repo,
    otp_app: :blinkup,
    adapter: Ecto.Adapters.Postgres
end
