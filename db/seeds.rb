puts "Seeding..."

# Companies
company = Company.create!(
  name:     "Acme Corp",
  slug:     "acme-corp",
  plan:     :pro,
  industry: "Technology"
)

# Sectors
engineering = Sector.create!(name: "Engineering",      company: company, color: "#6366f1")
marketing   = Sector.create!(name: "Marketing",        company: company, color: "#f59e0b")
hr          = Sector.create!(name: "Human Resources",  company: company, color: "#10b981")

# Super admin — no company (platform-level user)
super_admin = User.new(
  email:      "super@taskflow.com",
  password:   "password123",
  first_name: "Super",
  last_name:  "Admin",
  role:       :super_admin
)
super_admin.save!(validate: false)

# Company admin
admin = User.create!(
  email:      "admin@acme.com",
  password:   "password123",
  first_name: "Alice",
  last_name:  "Admin",
  role:       :admin,
  company:    company
)

# Manager
mgr1 = User.create!(
  email:      "manager@acme.com",
  password:   "password123",
  first_name: "Bob",
  last_name:  "Manager",
  role:       :manager,
  company:    company,
  sector:     engineering
)

# Employees
emp1 = User.create!(
  email:      "john@acme.com",
  password:   "password123",
  first_name: "John",
  last_name:  "Doe",
  role:       :employee,
  company:    company,
  sector:     engineering
)

emp2 = User.create!(
  email:      "jane@acme.com",
  password:   "password123",
  first_name: "Jane",
  last_name:  "Smith",
  role:       :employee,
  company:    company,
  sector:     marketing
)

# Sample tasks
ActsAsTenant.with_tenant(company) do
  Task.create!(
    title:       "Set up CI/CD pipeline",
    description: "Configure GitHub Actions for automated testing and deployment",
    status:      :in_progress,
    priority:    :high,
    creator:     mgr1,
    assignee:    emp1,
    sector:      engineering,
    due_date:    3.days.from_now,
    company:     company
  )

  Task.create!(
    title:       "Q3 Marketing campaign",
    description: "Plan and execute social media push for Q3",
    status:      :todo,
    priority:    :medium,
    creator:     admin,
    assignee:    emp2,
    sector:      marketing,
    due_date:    1.week.from_now,
    company:     company
  )

  Task.create!(
    title:       "Update onboarding docs",
    description: "Revise employee handbook with new policies",
    status:      :review,
    priority:    :low,
    creator:     admin,
    assignee:    emp1,
    sector:      hr,
    due_date:    2.weeks.from_now,
    company:     company
  )

  Task.create!(
    title:       "Fix login session bug",
    description: "Users reporting random session drops on mobile",
    status:      :todo,
    priority:    :urgent,
    creator:     mgr1,
    assignee:    emp1,
    sector:      engineering,
    due_date:    1.day.from_now,
    company:     company
  )
end

puts "Done!"
puts "Login: admin@acme.com / password123"
puts "Manager: manager@acme.com / password123"
puts "Employee: john@acme.com / password123"