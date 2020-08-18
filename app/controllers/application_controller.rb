class ApplicationController < ActionController::Base  
    before_action :configure_permitted_parameters, if: :devise_controller?

    
    def signed_in?
      if !user_signed_in?
          redirect_to new_user_session_path
      end
    end
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_picture])
    end
end
