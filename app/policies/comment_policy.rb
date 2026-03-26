class CommentPolicy < ApplicationPolicy
  def create?  = true
  def destroy? = record.user_id == user.id || user.manager_or_above?
end