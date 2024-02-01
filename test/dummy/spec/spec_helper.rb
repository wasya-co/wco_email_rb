
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'devise'

RSpec.configure do |config|
  config.use_active_record = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include Devise::TestHelpers, :type => :controller
  config.include FactoryBot::Syntax::Methods

end

blank_email_template = WcoEmail::EmailTemplate.find_or_create_by({ slug: 'blank' })

def destroy_every *args
  args.each do |arg|
    arg.unscoped.map &:destroy!
  end
end

def setup_users
  User.all.destroy_all
  user = User.create!( email: 'victor@wasya.co', password: 'test1234', provider: 'keycloakopenid' )
  Wco::Profile.unscoped.map &:destroy!
  p = Wco::Profile.create!( email: user.email )
  sign_in user
end

