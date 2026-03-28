source "https://rubygems.org"

ruby "3.4.4"

# Core
gem "rails", "~> 8.0.5"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

# Frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Auth & Permissions
gem "devise"
gem "pundit"

# Multi-tenancy
gem "acts_as_tenant"

# AI
gem "ruby-openai"

# Rate limiting
gem "rack-attack"

# Utilities
gem "ransack"
gem "noticed"
gem "image_processing", "~> 1.2"

# Deploy
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "annotate"
end