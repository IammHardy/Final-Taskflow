class SectorPolicy < ApplicationPolicy
  def index?   = true
  def show?    = true
    def new?
    create?
  end
  def create?  = user.manager_or_above?
  def update?  = user.manager_or_above?
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