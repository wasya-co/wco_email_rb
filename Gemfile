source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec



group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'

  gem 'omniauth', '~> 2.1.1'
  gem "omniauth-keycloak",              "~> 1.5.1"
  gem "omniauth-rails_csrf_protection", "~> 1.0.1" # required by wco_email, by keycloak to be in the host app.
  gem 'devise',    "~> 4.9.3"

end

