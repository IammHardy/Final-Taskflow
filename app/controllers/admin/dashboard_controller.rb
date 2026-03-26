class Admin::DashboardController < Admin::BaseController
  def index
    skip_authorization
    @companies = Company.all.order(:name)
    @users     = User.all.order(:created_at).limit(10)
    @stats = {
      companies: Company.count,
      users:     User.count,
      tasks:     Task.count
    }
  end
end