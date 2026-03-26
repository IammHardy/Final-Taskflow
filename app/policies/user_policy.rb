


class UserPolicy < ApplicationPolicy
  def index?   = user.manager_or_above?
  def show?    = user.manager_or_above? || record.id == user.id
  def new?     = user.admin_or_above?
  def create?  = user.admin_or_above?
  def edit?    = user.admin_or_above? || record.id == user.id
  def update?  = user.admin_or_above? || record.id == user.id
  def destroy? = user.admin_or_above?

  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(company: user.company)
      end
    end
  end
end