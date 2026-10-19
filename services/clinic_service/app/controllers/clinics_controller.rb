
class ClinicsController < ApplicationController
  before_action :set_clinic, only: %i[show edit update destroy]

  def index
    @clinics = Clinic.order(:name)
  end

  def show
  end

  def new
    @clinic = Clinic.new
  end

  def create
    @clinic = Clinic.new(clinic_params)

    if @clinic.save
      redirect_to @clinic, notice: "Clínica cadastrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @clinic.update(clinic_params)
      redirect_to @clinic, notice: "Clínica atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @clinic.destroy!

    redirect_to clinics_path,
                notice: "Clínica removida com sucesso.",
                status: :see_other
  end

  private

  def set_clinic
    @clinic = Clinic.find(params[:id])
  end

  def clinic_params
    params.require(:clinic).permit(:name)
  end
end
