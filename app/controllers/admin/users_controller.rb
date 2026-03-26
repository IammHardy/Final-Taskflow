class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    skip_authorization
    @users = User.includes(:company, :sector).order(:created_at)
  end

  def edit
    skip_authorization
  end

  def update
    skip_authorization
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    skip_authorization
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user = @user = User.find(params[:id])

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :company_id, :sector_id, :active)
  end
end