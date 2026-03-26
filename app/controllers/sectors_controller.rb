class SectorsController < ApplicationController
  before_action :set_sector, only: [:show, :edit, :update, :destroy]

  def index
    authorize Sector
    @sectors = policy_scope(Sector).order(:name)
  end

  def new
    @sector = Sector.new
    authorize @sector
  end

  def create
    @sector = Sector.new(sector_params)
    @sector.company = current_user.company
    authorize @sector
    if @sector.save
      redirect_to sectors_path, notice: "Sector created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit   = authorize @sector
  def show   = authorize @sector

  def update
    authorize @sector
    if @sector.update(sector_params)
      redirect_to sectors_path, notice: "Sector updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @sector
    @sector.destroy
    redirect_to sectors_path, notice: "Sector deleted."
  end

  private

  def set_sector = @sector = Sector.find(params[:id])
  def sector_params = params.require(:sector).permit(:name, :description, :color)
end