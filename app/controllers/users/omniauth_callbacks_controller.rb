class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Based on https://dev.to/jkevinbaluyot/google-login-rails-7-tutorial-1ai6
  def google_oauth2
    user = User.find_by(email: auth.info.email)

    if user.present?
      sign_out_all_scopes
      flash[:notice] = "Successfully logged in via Google"
      sign_in_and_redirect user, event: :authentication
    else
      Rails.logger.warn "Google login failed: #{auth.info}"
      flash[:alert] = "#{auth.info.email} is not registered. Contact the Data Marketplace team to request access."
      redirect_to new_user_session_path
    end
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
