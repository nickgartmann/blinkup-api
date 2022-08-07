defmodule BlinkupWeb.UserSessionController do
  use BlinkupWeb, :controller

  alias Blinkup.Accounts
  alias BlinkupWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do

    case user_params do
      %{"email" => email, "password" => password} ->
        if user = Accounts.get_user_by_email_and_password(email, password) do
          UserAuth.log_in_user(conn, user, user_params)
        else
          # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
          render(conn, "new.html", error_message: "Invalid email or password")
        end
      %{"phone_number" => phone_number} ->
        user = Accounts.get_or_create_user_with_phone_number(phone_number)
        Accounts.deliver_phone_verification_token(user)
        redirect(conn, to: "/users/verify")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
