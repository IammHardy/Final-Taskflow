class CompanyPolicy < ApplicationPolicy
  def index?   = user.super_admin?
  def show?    = user.super_admin? || record.id == user.company_id
  def create?  = user.super_admin?
  def update?  = user.super_admin? || (user.admin? && record.id == user.company_id)
  def destroy? = user.super_admin?
end