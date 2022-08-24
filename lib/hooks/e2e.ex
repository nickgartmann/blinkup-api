defmodule Blinkup.E2EHooks do

  # Seed data for the E2E environment
  def post_load() do
    Task.async(fn ->
      try do
        {:ok, user} = Blinkup.Accounts.get_or_create_user_with_phone_number("4141111111")
        Blinkup.Repo.insert!(%Blinkup.Accounts.UserToken{token: "asdf", context: "session", user_id: user.id})
      rescue 
        _ -> nil
      end
    end)
  end

end
