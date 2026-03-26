class TaskPolicy < ApplicationPolicy
  def index?  = true
  def show?   = member_of_company?
  def create? = user.manager_or_above?
  def update? = owner_or_manager?
  def destroy? = user.manager_or_above?

    def new?
    create?
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

  def member_of_company? = record.company_id == user.company_id
  def owner_or_manager?  = user.manager_or_above? || record.assignee_id == user.id || record.creator_id == user.id
end