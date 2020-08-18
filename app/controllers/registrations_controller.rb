class RegistrationsController < Devise::RegistrationsController
    def sign_up_params
        params.require(:user).permit(:name, :profile_picture, :email, :password, :password_confirmation)
    end
end