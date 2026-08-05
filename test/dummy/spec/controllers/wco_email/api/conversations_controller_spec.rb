

describe WcoEmail::Api::ConversationsController do
  render_views
  routes { WcoEmail::Engine.routes }

  describe 'routes' do
    it 'does' do
      expect(get: '/api/conversations').to route_to(controller: 'wco_email/api/conversations', action: 'index')
    end
  end

  before do
    setup_users

    destroy_every(
      Wco::Tag,
      WcoEmail::Conversation,
    )
    @inbox = Wco::Tag.inbox
  end

  describe '#index' do
    it 'json api' do
      @conv = create(:email_conversation, tags: [ @inbox ])
      get :index, format: :json
      response.code.should eql '200'
      assigns(:conversations).length.should > 0
    end
  end
end
