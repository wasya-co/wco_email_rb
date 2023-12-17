
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec



group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', "~> 6.1.0"
  gem 'rails-controller-testing', "~> 1.0.5"

  ## Nothing gets pulled via gemspec ?!
  gem 'ish_models', '~> 3.1.0.13'
  # gem 'cancancan', "~> 3.5.0"
  # gem 'devise',    "~> 4.9.3"

  gem 'omniauth', '~> 2.1.1'
  gem "omniauth-keycloak",              "~> 1.5.1"
  ## Required by wco_email, by keycloak to be in the host app.
  # gem "omniauth-rails_csrf_protection", "~> 1.0.1"


end

