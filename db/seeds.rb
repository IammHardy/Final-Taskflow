puts "Seeding..."

# Companies
company = Company.find_or_create_by!(slug: "acme-corp") do |c|
  c.name     = "Acme Corp"
  c.plan     = :pro
  c.industry = "Technology"
end

# Sectors
engineering = Sector.find_or_create_by!(name: "Engineering", company: company) do |s|
  s.color = "#6366f1"
end

marketing = Sector.find_or_create_by!(name: "Marketing", company: company) do |s|
  s.color = "#f59e0b"
end

hr = Sector.find_or_create_by!(name: "Human Resources", company: company) do |s|
  s.color = "#10b981"
end

# Super admin
super_admin = User.find_or_initialize_by(email: "super@taskflow.com")
if super_admin.new_record?
  super_admin.first_name = "Super"
  super_admin.last_name  = "Admin"
  super_admin.role       = :super_admin
  super_admin.password   = "password123"
  super_admin.save!(validate: false)
end

# Company admin
admin = User.find_or_create_by!(email: "admin@acme.com") do |u|
  u.first_name = "Alice"
  u.last_name  = "Admin"
  u.role       = :admin
  u.company    = company
  u.password   = "password123"
end

# Manager
mgr = User.find_or_create_by!(email: "manager@acme.com") do |u|
  u.first_name = "Bob"
  u.last_name  = "Manager"
  u.role       = :manager
  u.company    = company
  u.sector     = engineering
  u.password   = "password123"
end

# Employees
emp1 = User.find_or_create_by!(email: "john@acme.com") do |u|
  u.first_name = "John"
  u.last_name  = "Doe"
  u.role       = :employee
  u.company    = company
  u.sector     = engineering
  u.password   = "password123"
end

emp2 = User.find_or_create_by!(email: "jane@acme.com") do |u|
  u.first_name = "Jane"
  u.last_name  = "Smith"
  u.role       = :employee
  u.company    = company
  u.sector     = marketing
  u.password   = "password123"
end

# Sample tasks
ActsAsTenant.with_tenant(company) do
  Task.find_or_create_by!(title: "Set up CI/CD pipeline", company: company) do |t|
    t.description = "Configure GitHub Actions"
    t.status      = :in_progress
    t.priority    = :high
    t.creator     = mgr
    t.assignee    = emp1
    t.sector      = engineering
    t.due_date    = 3.days.from_now
  end

  Task.find_or_create_by!(title: "Q3 Marketing campaign", company: company) do |t|
    t.description = "Plan social media push"
    t.status      = :todo
    t.priority    = :medium
    t.creator     = admin
    t.assignee    = emp2
    t.sector      = marketing
    t.due_date    = 1.week.from_now
  end

  Task.find_or_create_by!(title: "Fix login session bug", company: company) do |t|
    t.description = "Users reporting random session drops"
    t.status      = :todo
    t.priority    = :urgent
    t.creator     = mgr
    t.assignee    = emp1
    t.sector      = engineering
    t.due_date    = 1.day.from_now
  end
end

puts "Done!"
puts "Login: admin@acme.com / password123"