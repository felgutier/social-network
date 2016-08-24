class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted? and @user.email != "update@me.com"
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.auth"] = request.env["omniauth.auth"]
          render :edit
        end
        session["devise.auth"] = request.env["omniauth.auth"]
      end
    }
    
  end

  [:twitter, :facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  def custom_sign_up
    @user = User.find_for_oauth(session["devise.auth"], current_user)
    if @user.update(user_params)
      sign_in_and_redirect @user, event: :authentication_keys
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :username)
  end

end
