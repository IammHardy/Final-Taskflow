class ProfileController < ApplicationController
  def show
    skip_authorization
    @user = current_user
  end

  def edit
    skip_authorization
    @user = current_user
  end

  def update
    skip_authorization
    @user = current_user

    if params[:user][:password].present?
      # Password change — requires current password
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(password_params)
          bypass_sign_in(@user)
          redirect_to profile_path, notice: "Password updated successfully."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "is incorrect")
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(profile_params)
        redirect_to profile_path, notice: "Profile updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :phone)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end