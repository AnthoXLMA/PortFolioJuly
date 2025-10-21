require_relative "boot"

# Charger uniquement les frameworks nécessaires
require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "active_model/railtie"
require "sprockets/railtie"
# require "active_record/railtie" # pas de DB
# require "active_storage/engine" # pas de fichiers à gérer
# require "rails/test_unit/railtie" # pas de TestUnit

# Charger les gems du Gemfile
Bundler.require(*Rails.groups)

module GPortfolio
  class Application < Rails::Application
    # Pas besoin de master key sur Render
    config.require_master_key = false

    # Initialiser les defaults pour Rails 7.1
    config.load_defaults 7.1

    # Ignorer certains dossiers lib inutiles pour l'autoload
    config.autoload_lib(ignore: %w[assets tasks])

    # Désactiver ActiveRecord et générateurs DB
    config.api_only = false
    config.generators.orm = nil
  end
end
