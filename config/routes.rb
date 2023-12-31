
WcoEmail::Engine.routes.draw do
  # root to: '/wco_email/email_conversations#index'
  root to: redirect('/email/conversations')

  get 'analytics', to: 'application#analytics'
  get 'tinymce',   to: 'application#tinymce', as: :application_tinymce

  get 'conversations',                     to: '/wco_email/conversations#index', as: :email_conversations
  get 'conversations/in/:tagname',         to: '/wco_email/conversations#index', as: :email_conversations_in
  get 'conversations/not-in/:tagname_not', to: '/wco_email/conversations#index', as: :email_conversations_in_not
  get 'conversations/:id',                 to: '/wco_email/conversations#show',  as: :email_conversation
  post 'conversations/:id1/merge/:id2',    to: '/wco_email/conversations#merge', as: :merge_email_conversations
  # resources :conversations

  resources :email_action_templates
  resources :email_actions
  resources :email_campaigns
  resources :email_layouts

  get  'contexts/iframe_src/:id',     to: 'contexts#iframe_src',       as: :email_context_iframe
  get  'contexts/summary',            to: 'contexts#summary'
  post 'contexts/send_immediate/:id', to: 'contexts#send_immediate',   as: :send_immediate_email_context
  resources :contexts
  resources :email_filters
  get 'email_templates/:id/iframe', to: 'email_templates#show_iframe', as: :email_template_iframe
  resources :email_templates

  resources :lead_action_templates
  resources :lead_actions

  get 'messages/:id/iframe', to: 'messages#show_iframe', as: :message_iframe
  resources :messages

  post 'message_stub/:id/churn', to: 'message_stubs#churn', as: :churn_message_stub
  resources :message_stubs

  get '/obf/:id', to: 'obfuscated_redirects#show', as: :obf



  resources :unsubscribes


end
