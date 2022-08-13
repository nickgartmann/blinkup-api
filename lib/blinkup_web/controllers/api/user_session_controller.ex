defmodule BlinkupWeb.Api.UserSessionController do
  use BlinkupWeb, :controller

  alias Blinkup.Accounts
  alias BlinkupWeb.UserAuth

  def show(conn, %{}) do
    user = conn.assigns.current_user
    json(conn, %{"user" => user})
  end

  def create(conn, %{"user" => %{"phone_number" => phone_number}}) do
    {:ok, user} = Accounts.get_or_create_user_with_phone_number(phone_number)
    Accounts.deliver_phone_verification_token(user)
    json(conn, %{ "message" => "Sent token to phone" })
  end

  def verify(conn, %{"token" => token}) do
    case Accounts.validate_session(token) do
      {:ok, user} ->
        token = Accounts.generate_user_session_token(user)
        json(conn, %{
          "user" => user,
          "auth_token" => Base.url_encode64(token)
        })
      :error ->
        json(conn, %{"error" => "Failed to validate token"})
    end
  end

  def otp(conn, %{"phone" => phone_number}) do
    if Mix.env() in [:test] do 
      otp = Blinkup.OTPRegistry.get("session:#{phone_number}")
      json(conn, %{"otp" => otp})
    end
  end

end
