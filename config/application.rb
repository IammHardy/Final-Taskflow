require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Taskflow
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_job.queue_adapter = ENV["RAILS_ENV"] == "production" ? :async : :solid_queue
    config.middleware.use Rack::Attack
  end
end
