
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

require 'devise'

Bundler.require(*Rails.groups)
require "wco_email"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Central Time (US & Canada)'
  end
end

DEBUG ||= true

