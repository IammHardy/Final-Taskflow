class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user   = user
    @record = record
  end

  def index?   = user.admin_or_above?
  def show?    = user.admin_or_above?
  def create?  = user.admin_or_above?
  def update?  = user.admin_or_above?
  def destroy? = user.admin_or_above?

  class Scope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def resolve
    scope.all
  end
end
end