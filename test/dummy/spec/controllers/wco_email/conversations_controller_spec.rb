
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

  describe '#addtag' do
    it 'adds one and moves' do
      inbox = Wco::Tag.inbox
      tag1  = create( :tag )
      tag2  = create( :tag )
      conv  = create( :email_conversation, tags: [ inbox, tag1 ] )

      post :addtag, params: { slug: tag2.slug, is_move: true, ids: [ conv.id ] }
      conv.reload

      # puts! conv.tags.map(&:slug), 'actual tags'
      conv.tag_ids.should eql( [ tag1.id, tag2.id ] )
    end
  end

  describe "#index" do
    it 'does' do
      get :index
      response.code.should eql '200'
    end

    it 'in tagname' do
      conv = WcoEmail::Conversation.create( subject: 'test subj 1', tags: [ @inbox ] )

      get :index, params: { tagname: 'inbox' }

      convs = assigns( :conversations )
      convs.length.should > 0
      convs.each do |conv|
        conv.tags.include?( @inbox ).should eql true
      end
    end

  end

  it '#rmtag' do
    tag1  = create( :tag )
    conv  = create( :email_conversation, tags: [ tag1 ] )

    post :rmtag, params: { slug: tag1.slug, ids: [ conv.id ] }
    conv.reload

    conv.tag_ids.should eql( [] )
  end

  describe '#show' do
    it 'does' do
      Wco::Lead.unscoped.map             &:destroy!
      WcoEmail::Message.unscoped.map     &:destroy!
      WcoEmail::MessageStub.unscoped.map &:destroy!

      conv = create( :email_conversation )
      msg  = create( :email_message, {
        conversation: conv,
        lead: create(:lead),
      })

      get :show, params: { id: conv.id }
      response.code.should eql '200'
    end
  end

end

