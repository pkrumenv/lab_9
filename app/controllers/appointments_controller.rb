class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index
    @appointments = policy_scope(Appointment)
  end

  def show
    authorize @appointment
    @treatments = @appointment.treatments.with_rich_text_clinical_notes
  end

  def new
    @appointment = Appointment.new
    authorize @appointment
  end

  def create
    @appointment = Appointment.new(appointment_params)
    
    # Por seguridad, si es veterinario, nos aseguramos de que la cita sea para él
    if current_user.vet?
      @appointment.vet = current_user.vet
    end

    authorize @appointment

    if @appointment.save
      redirect_to @appointment, notice: 'Appointment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @appointment
  end

  def update
    authorize @appointment
    
    if @appointment.update(permitted_attributes(@appointment))
      redirect_to @appointment, notice: "Appointment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @appointment
    @appointment.destroy
    redirect_to appointments_url, notice: "Appointment was successfully deleted."
  end

  private

  def appointment_params
    params.require(:appointment).permit(:pet_id, :vet_id, :date, :reason, :status)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

end