require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DmClientDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    dm_client_id = ENV.fetch("DM_CLIENT_ID", Rails.application.credentials&.dm_api&.fetch(:clientId, "id"))
    dm_client_secret = ENV.fetch("DM_CLIENT_SECRET", Rails.application.credentials&.dm_api&.fetch(:clientSecret, "secret"))

    config.dm_api = {
      clientId: dm_client_id,
      clientSecret: dm_client_secret,
    }

    config.dm_api_root_url = ENV.fetch("DM_API_ROOT_URL", Rails.application.credentials&.dm_api&.fetch(:rootApiUrl, "apitest.datamarketplace.gov.uk"))
    config.dm_root_url = ENV.fetch("DM_ROOT_URL", Rails.application.credentials&.dm_api&.fetch(:rootUrl, "test.datamarketplace.gov.uk"))

    google_client_id = ENV.fetch("GOOGLE_CLIENT_ID", Rails.application.credentials&.google&.fetch(:clientId, "id"))
    google_client_secret = ENV.fetch("GOOGLE_CLIENT_SECRET", Rails.application.credentials&.google&.fetch(:clientSecret, "secret"))

    config.google = {
      clientId: google_client_id,
      clientSecret: google_client_secret,
    }
  end
end
