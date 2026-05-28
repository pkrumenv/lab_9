class OwnerPolicy < ApplicationPolicy
  def index?
    user.admin? || user.vet? 
  end

  def show?
    user.admin? || user.vet? || (user.owner? && record.user_id == user.id)
  end

  def update?
    user.admin? || (user.owner? && record.user_id == user.id)
  end

  def edit?
    update?
  end

  def permitted_attributes
    if user.admin? || (user.owner? && record.user_id == user.id)
      [:first_name, :last_name, :email, :phone]
    else
      []
    end
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.vet?
        scope.all
      elsif user.owner?
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end