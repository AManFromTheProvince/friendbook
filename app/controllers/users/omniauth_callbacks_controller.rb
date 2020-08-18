class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
    
        if @user.persisted?
          flash[:success] = "Successfully signed in!"
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        else
          session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
          redirect_to new_user_registration_url
        end
      end
    
      def failure
        flash[:fail] = "Failed to log in using Facebook. Please use the Sign up page!"
        redirect_to root_path
      end
end