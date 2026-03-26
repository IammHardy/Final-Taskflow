
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
  authorize User
  @users = policy_scope(User).includes(:sector, :assigned_tasks).order(:first_name)
  @users = @users.where(sector_id: params[:sector_id]) if params[:sector_id].present?
end

  def show
    authorize @user
  end

  def new
    authorize User, :create?
    @user = User.new
    @user.sector_id = params[:sector_id] if params[:sector_id]
  end

  def create
    authorize User, :create?
    @user = User.new(user_params)
    @user.company = current_user.company

    # Set default password if not provided
    default_password = user_params[:password].presence || "Taskflow@#{rand(1000..9999)}"
    @user.password              = default_password
    @user.password_confirmation = default_password

    if @user.save
      # Store default password in flash so admin can share it
      flash[:notice] = "User created! Default password: #{default_password} — share this with them."
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  

  def edit
    authorize @user
  end

  def update
    authorize @user
    params_to_update = user_params_update
    # Only update password if provided
    if params[:user][:password].blank?
      params_to_update = params_to_update.except(:password, :password_confirmation)
    end

    if @user.update(params_to_update)
      redirect_to users_path, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, notice: "User removed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :phone,
      :sector_id, :active, :password, :password_confirmation,
      *role_params
    )
  end

  def user_params_update
    params.require(:user).permit(
      :first_name, :last_name, :phone,
      :sector_id, :active, :password, :password_confirmation,
      *role_params
    )
  end

  def role_params
    current_user.admin_or_above? ? [:role] : []
  end
end