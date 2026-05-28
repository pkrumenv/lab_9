class VetPolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    true 
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || (user.vet? && record.user_id == user.id)
  end
  
  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    if user.admin? || (user.vet? && record.user_id == user.id)
      [:first_name, :last_name, :specialization, :email, :phone]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end



end