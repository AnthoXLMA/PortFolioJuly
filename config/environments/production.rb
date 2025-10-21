require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot
  config.eager_load = true

  # Full error reports are disabled, caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Force all access to the app over SSL
  config.force_ssl = true

  # Log to STDOUT
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Assets
  config.assets.compile = false
  config.assets.quiet   = true
  config.active_storage.service = :cloudinary


  # I18n fallback
  config.i18n.fallbacks = true

  # Deprecation notices
  config.active_support.report_deprecations = false

  # ActiveStorage (Cloudinary)
  # Décommente et configure Cloudinary si tu veux stocker des fichiers
  # config.active_storage.service = :cloudinary

  # Action Mailer
  config.action_mailer.perform_caching = false
end
