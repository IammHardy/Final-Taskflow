require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.active_storage.service = :local
  config.assume_ssl = true
  config.force_ssl = true

  config.log_tags  = [:request_id]
  config.logger    = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = :info
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # Cache — memory store (no Redis/Solid needed)
  config.cache_store = :memory_store, { size: 64.megabytes }

  # Jobs — async (no Solid Queue needed)
  config.active_job.queue_adapter = :async

  # Action Cable — async (no Solid Cable needed)
  config.action_cable.cable = { "adapter" => "async" }

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "example.com" }
  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  config.secret_key_base = ENV["SECRET_KEY_BASE"]
end