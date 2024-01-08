
describe WcoEmail::ConversationsController do
  render_views
  routes { WcoEmail::Engine.routes }

  describe 'routes' do
    it 'does' do
      expect(get: '/conversations').to              route_to(controller: 'wco_email/conversations', action: 'index')
      expect(get: '/conversations/in/inbox').to     route_to(controller: 'wco_email/conversations', action: 'index', tagname: 'inbox')
      expect(get: '/conversations/not-in/inbox').to route_to(controller: 'wco_email/conversations', action: 'index', tagname_not: 'inbox')
    end
  end

  before do
    setup_users

    Wco::Tag.unscoped.map &:destroy!
    @inbox = create( :tag, slug: 'inbox' )
  end

  describe "#index" do
    it 'does' do
      get :index
      response.code.should eql '200'
    end

    it 'in tagname' do
      conv = WcoEmail::Conversation.create( subject: 'test subj 1', tags: [ @inbox ] )

      get :index, params: { tagname: 'inbox' }

      convs = assigns(:email_conversations)
      convs.length.should > 0
      convs.each do |conv|
        conv.tags.include?( @inbox ).should eql true
      end
    end

  end

  describe '#show' do
    it 'does' do
      conv = create( :email_conversation )
      get :show, params: { id: conv.id }
      response.code.should eql '200'
    end
  end

end

