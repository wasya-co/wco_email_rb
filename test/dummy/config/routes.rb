
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == BASIC_AUTH_NAME && password == BASIC_AUTH_PASSWORD
end

Rails.application.routes.draw do
  root to: 'application#home'
  # root to: redirect('/email')


  mount WcoEmail::Engine => "/email"
  mount Sidekiq::Web => '/sidekiq'
  mount Wco::Engine => '/wco'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  resources :users

end
