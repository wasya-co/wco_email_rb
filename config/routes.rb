
WcoEmail::Engine.routes.draw do
  # root to: '/wco_email/email_conversations#index'
  root to: redirect('/email/email_conversations')

  get 'analytics', to: 'application#analytics'
  get 'tinymce',   to: 'application#tinymce', as: :application_tinymce

  get 'email_conversations',                     to: '/wco_email/conversations#index', as: :email_conversations
  get 'email_conversations/in/:tagname',         to: '/wco_email/conversations#index', as: :email_conversations_in
  get 'email_conversations/not-in/:tagname_not', to: '/wco_email/conversations#index', as: :email_conversations_in_not
  get 'email_conversations/:id',                 to: '/wco_email/conversations#show',  as: :email_conversation
  # resources :email_conversations

  resources :email_actions
  resources :email_campaigns

  get 'email_contexts/summary', to: 'email_contexts#summary'
  resources :email_contexts
  resources :email_filters
  resources :email_templates


  resources :lead_action_templates
  resources :lead_actions

  resources :office_actions

  resources :scheduled_email_actions

  # resources :tags

  resources :unsubscribes


end
