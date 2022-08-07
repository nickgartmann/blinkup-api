defmodule BlinkupWeb.Api.UserSessionController do
  use BlinkupWeb, :controller

  alias Blinkup.Accounts
  alias BlinkupWeb.UserAuth

  def create(conn, %{"user" => %{"phone_number" => phone_number}}) do
    user = Accounts.get_or_create_user_with_phone_number(phone_number)
    Accounts.deliver_phone_verification_token(user)
    json(conn, %{ "user" => user })
  end

  def verify(conn, %{"token" => token}) do
    case Accounts.validate_session(token) do
      {:ok, _} ->
        :pass
      :error ->
        :pass 
    end

  end

end
