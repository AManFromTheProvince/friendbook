class RegistrationsController < Devise::RegistrationsController
    def sign_up_params
        params.require(:user).permit(:name, :profile_picture, :email, :password, :password_confirmation)
    end

    def update_resource(resource, params)
        if current_user.provider == "facebook"
            params.delete("current_password")
            resource.update_without_password(params)
        else
            resource.update_with_password(params)
        end
    end
end