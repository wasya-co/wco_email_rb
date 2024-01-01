
WcoEmail::Engine.routes.draw do
  # root to: '/wco_email/email_conversations#index'
  root to: redirect('/email/conversations')

  get 'analytics', to: 'application#analytics'
  get 'tinymce',   to: 'application#tinymce', as: :application_tinymce

  get 'conversations',                     to: '/wco_email/conversations#index', as: :email_conversations
  get 'conversations/in/:tagname',         to: '/wco_email/conversations#index', as: :email_conversations_in
  get 'conversations/not-in/:tagname_not', to: '/wco_email/conversations#index', as: :email_conversations_in_not
  get 'conversations/:id',                 to: '/wco_email/conversations#show',  as: :email_conversation
  # resources :conversations

  resources :email_actions
  resources :email_campaigns

  get 'email_contexts/summary', to: 'email_contexts#summary'
  post 'email_contexts/send_immediate/:id',      to: 'email_contexts#send_immediate',   as: :send_immediate_email_context
  resources :email_contexts
  resources :email_filters
  resources :email_templates


  resources :lead_action_templates
  resources :lead_actions

  get 'messages/:id/iframe', to: 'messages#show_iframe', as: :message_iframe
  resources :messages

  resources :office_actions

  resources :scheduled_email_actions

  resources :unsubscribes


end
