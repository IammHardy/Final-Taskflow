class UserPolicy < ApplicationPolicy
  def index?
    return true if user.super_admin?
    user.manager_or_above?
  end

  def show?
    return true if user.super_admin?
    record.company_id == user.company_id
  end

  def new?
    create?
  end

  def create?
    return true if user.super_admin?
    user.admin?
  end

  def edit?
    update?
  end

  def update?
    return true if user.super_admin?
    record.company_id == user.company_id && user.admin?
  end

  def destroy?
    return true if user.super_admin?
    record.company_id == user.company_id && user.admin?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.super_admin?
      scope.where(company: user.company)
    end
  end
end