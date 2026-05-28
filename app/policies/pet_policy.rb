class PetPolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    user.admin? || user.vet? || (user.owner? && record.owner.user_id == user.id)
  end

  def create?
    user.admin? || user.owner?
  end

  def update?
    user.admin? || (user.owner? && record.owner.user_id == user.id)
  end

  def destroy?
    update?
  end

  def permitted_attributes
    if user.admin?
      [:name, :species, :breed, :weight, :date_of_birth, :photo, :owner_id]
    else
      [:name, :species, :breed, :weight, :date_of_birth, :photo]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.vet?
        scope.all
      elsif user.owner?
        scope.joins(:owner).where(owners: { user_id: user.id })
      end
    end
  end
end