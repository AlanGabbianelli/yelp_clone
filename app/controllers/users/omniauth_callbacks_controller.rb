class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      # In the new Facebook login dialog the user can decline to provide email address.
      # Devise usually requires email to register. A quick and dirty solution to
      # this problem is to re-request the email if it wasn't found:
      if request.env['omniauth.auth'].info.email.blank?
        redirect_to '/users/auth/facebook?auth_type=rerequest&scope=email'
      end
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
