class TreatmentPolicy < ApplicationPolicy
  def create?
    user.admin? || (user.vet? && record.appointment.vet.user_id == user.id)
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    if user.admin? || (user.vet? && record.appointment.vet == user.vet)
      [:name, :clinical_notes, :administered_at, :appointment_id] 
    elsif user.vet?
      [:clinical_notes, :administered_at] 
    else
      []
    end
  end
end