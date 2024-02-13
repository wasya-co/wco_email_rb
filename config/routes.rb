
WcoEmail::Engine.routes.draw do
  # root to: '/wco_email/email_conversations#index'
  root to: redirect('/email/conversations/in/inbox')

  get 'analytics', to: 'application#analytics'
  get 'tinymce',   to: 'application#tinymce', as: :application_tinymce

  get  'conversations/in/:tagname',         to: '/wco_email/conversations#index', as: :conversations_in
  get  'conversations/not-in/:tagname_not', to: '/wco_email/conversations#index', as: :conversations_not_in
  get  'conversations/:id',                 to: '/wco_email/conversations#show',  as: :conversation
  post 'conversations/:id1/merge/:id2',     to: '/wco_email/conversations#merge', as: :merge_conversations
  post 'conversations/addtag',              to: 'conversations#addtag'
  post 'conversations/addtag/:slug',        to: 'conversations#addtag'
  post 'conversations/rmtag',               to: 'conversations#rmtag'
  post 'conversations/rmtag/:slug',         to: 'conversations#rmtag'
  resources :conversations

  post 'email_action_templates', to: 'email_action_templates#update'
  resources :email_action_templates
  resources :email_actions
  resources :email_campaigns
  resources :email_layouts

  get  'contexts/show_iframe/:id',    to: 'contexts#show_iframe',       as: :context_iframe
  get  'contexts/summary',            to: 'contexts#summary'
  post 'contexts/send_immediate/:id', to: 'contexts#send_immediate',   as: :send_context
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

  ## In order to have unsubscribes_url , unsubscribes must be in wco .
  # resources :unsubscribes

end
