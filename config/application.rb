require_relative "boot"

# Ne pas charger ActiveRecord ni les autres frameworks inutiles
require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "active_storage/engine"

# require "rails/test_unit/railtie" # si tu n'utilises pas TestUnit

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GPortfolio
  class Application < Rails::Application
    # Ne pas exiger la master key pour Render
    config.require_master_key = false

    # Initialiser les defaults pour Rails 7.1
    config.load_defaults 7.1

    # Ignorer certains dossiers dans `lib` pour l'autoload
    config.autoload_lib(ignore: %w(assets tasks))

    # Désactiver ActiveRecord (pas de DB)
    config.api_only = false
    config.generators do |g|
      g.orm nil
    end
  end
end
