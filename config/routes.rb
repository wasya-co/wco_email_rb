
WcoEmail::Engine.routes.draw do
  root to: '/wco_email/application#home'

  get 'analytics', to: 'application#analytics'
  get 'tinymce',   to: 'application#tinymce', as: :application_tinymce

  get 'email_conversations',                     to: '/wco_email/email_conversations#index'
  get 'email_conversations/in/:tagname',         to: '/wco_email/email_conversations#index', as: :email_conversations_in
  get 'email_conversations/not-in/:tagname_not', to: '/wco_email/email_conversations#index', as: :email_conversations_in_not
  # resources :email_canversations

  resources :email_actions
  resources :email_campaigns

  get 'email_contexts/summary', to: 'email_contexts#summary'
  resources :email_contexts
  resources :email_filters
  resources :email_templates

  resources :lead_action_templates
  resources :lead_actions
  resources :leads
  resources :leadsets

  resources :office_actions

  resources :profiles
  resources :publishers

  resources :scheduled_email_actions

  resources :tags

  resources :unsubscribes


end
