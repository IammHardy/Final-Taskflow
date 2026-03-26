class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :edit, :update, :destroy]

  def index
    skip_authorization
    @users = User.includes(:company, :sector).order(:created_at)
  end

  def new
    skip_authorization
    @user = User.new
    @user.company_id = params[:company_id] if params[:company_id]
  end

 def create
  skip_authorization
  @user = User.new(admin_user_params)

  default_password = admin_user_params[:password].presence || "Taskflow@#{rand(1000..9999)}"
  @user.password = default_password
  @user.password_confirmation = default_password

  ActsAsTenant.with_mutable_tenant do
    if @user.save
      flash[:notice] = "User created! Default password: #{default_password}"
      redirect_to admin_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end
end

  def edit
    skip_authorization
  end

 def update
  skip_authorization
  update_params = admin_user_params
  update_params = update_params.except(:password, :password_confirmation) if params[:user][:password].blank?

  new_company_id = update_params[:company_id].presence
  new_sector_id  = update_params[:sector_id].presence

  if new_company_id.present? && new_sector_id.present?
    sector = Sector.find_by(id: new_sector_id)
    update_params[:sector_id] = nil if sector && sector.company_id.to_s != new_company_id.to_s
  end

  ActsAsTenant.with_mutable_tenant do
    if @user.update(update_params)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
end

  def destroy
    skip_authorization
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user = @user = User.find(params[:id])

  def admin_user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :phone,
      :role, :company_id, :sector_id, :active,
      :password, :password_confirmation
    )
  end
end