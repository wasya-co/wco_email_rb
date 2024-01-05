
describe WcoEmail::ConversationsController do
  render_views
  routes { WcoEmail::Engine.routes }

  describe 'routes' do
    it 'does' do
      expect(get: '/email_conversations').to              route_to(controller: 'wco_email/email_conversations', action: 'index')
      expect(get: '/email_conversations/in/inbox').to     route_to(controller: 'wco_email/email_conversations', action: 'index', tagname: 'inbox')
      expect(get: '/email_conversations/not-in/inbox').to route_to(controller: 'wco_email/email_conversations', action: 'index', tagname_not: 'inbox')
    end
  end

  describe "#index" do
    before do
      User.all.destroy_all
      user = User.create!( email: 'victor@wasya.co', password: 'test1234', provider: 'keycloakopenid' )
      Wco::Profile.unscoped.map &:destroy!
      p = Wco::Profile.create!( email: user.email )
      sign_in user

      Wco::Tag.all.destroy_all
      @inbox = Wco::Tag.create({ slug: 'inbox' })
    end

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

end

