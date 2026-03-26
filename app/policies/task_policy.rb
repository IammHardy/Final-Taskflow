class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if user.super_admin?
    member_of_company?
  end

  def new?
    create?
  end

  def create?
    return true if user.super_admin?
    user.manager_or_above?
  end

  def edit?
    update?
  end

  def update?
    return true if user.super_admin?
    owner_or_manager?
  end

  def destroy?
    return true if user.super_admin?
    user.manager_or_above?
  end

  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(company: user.company)
      end
    end
  end

  private

  def member_of_company?
    record.company_id == user.company_id
  end

  def owner_or_manager?
    return false unless member_of_company?
    user.manager_or_above? || record.assignee_id == user.id || record.creator_id == user.id
  end
end