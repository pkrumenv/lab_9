class AppointmentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin? || 
    (user.vet? && record.vet.user_id == user.id) || 
    (user.owner? && record.pet.owner.user_id == user.id)
  end

  def create?
    user.admin? || user.vet? || user.owner?
  end

  def update?
    show?
  end

  def edit?
    update?
  end

  def destroy?
    show?
  end

  def permitted_attributes
    if user.admin?
      [:date, :reason, :vet_id, :pet_id]
    elsif user.vet?
      [:date, :reason, :pet_id]
    elsif user.owner?
      [:date, :reason, :vet_id]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.vet?
        scope.joins(:vet).where(vets: { user_id: user.id })
      elsif user.owner?
        scope.joins(pet: :owner).where(owners: { user_id: user.id })
      else
        scope.none
      end
    end
  end
end