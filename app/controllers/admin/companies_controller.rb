class Admin::CompaniesController < Admin::BaseController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    skip_authorization
    @companies = Company.all.order(:name)
  end

  def show
    skip_authorization
  end

  def new
    skip_authorization
    @company = Company.new
  end

  def create
    skip_authorization
    @company = Company.new(company_params)
    if @company.save
      redirect_to admin_companies_path, notice: "Company created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    skip_authorization
  end

  def update
    skip_authorization
    if @company.update(company_params)
      redirect_to admin_companies_path, notice: "Company updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    skip_authorization
    @company.destroy
    redirect_to admin_companies_path, notice: "Company deleted."
  end

  private

  def set_company = @company = Company.find(params[:id])

  def company_params
    params.require(:company).permit(:name, :slug, :industry, :plan, :active)
  end
end