module UsersHelper
  def login_button
    govuk_button_to(
      "Login with Google",
      user_google_oauth2_omniauth_authorize_path,
      method: :post,
      data: { turbo: "false" },
      secondary: true,
    )
  end

  def logout_button
    govuk_button_to(
      "Logout",
      destroy_user_session_path,
      method: :delete,
      data: { turbo: "false" },
      secondary: true,
    )
  end
end
