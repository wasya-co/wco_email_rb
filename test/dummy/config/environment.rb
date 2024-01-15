
require_relative "application"
Rails.application.initialize!
Rails.backtrace_cleaner.remove_silencers! if ENV["BACKTRACE"]
Rails.application.config.action_dispatch.cookies_serializer = :json
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :crypt, :salt, :certificate, :otp, :ssn
]
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json]
end

