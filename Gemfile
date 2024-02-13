
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'mongoid',           '~> 7.3.0'
gem 'mongoid_paranoia',  '~> 0.6.0'
gem 'mongoid-autoinc',   '~> 6.0.3'
gem 'mongoid-paperclip', '~> 0.1.0'

gem 'omniauth',                       '~> 2.1.1'
gem "omniauth-keycloak",              "~> 1.5.1"
gem "omniauth-rails_csrf_protection", "~> 1.0.1"

gem 'jbuilder', '~> 2.11.5'

group :development, :test do
  gem 'byebug'

  gem 'factory_bot_rails'

  gem 'irb', '>= 1.2.8'

  gem 'kaminari-mongoid'
  gem 'kaminari-actionview'

  ## https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'

  gem 'rspec-rails', "~> 6.1.0"
  gem 'rails-controller-testing', "~> 1.0.5"

  gem 'sass-rails', "~> 6.0"

  gem 'wco_models',  github: 'wasya-co/wco_models',     branch: '3.1.0'


end

