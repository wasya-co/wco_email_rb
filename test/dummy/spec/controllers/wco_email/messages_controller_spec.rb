
describe WcoEmail::MessagesController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    setup_users
    destroy_every(
      Wco::Lead,
      WcoEmail::Message,
      WcoEmail::MessageStub,
      WcoEmail::Conversation,
      WcoEmail::EmailActionTemplate,
      WcoEmail::EmailAction,
      WcoEmail::EmailTemplate,
    );
    @lead = create(:lead)
    @conv = create(:email_conversation)
    @stub = create(:message_stub, object_key: '2021-10-18T18_41_17Fanand_phoenixwebgroup_co' )
    @message = create(:email_message, lead: @lead, conversation: @conv, stub: @stub )
  end

  it '#show' do
    get :show, params: { id: @message.id }
    response.code.should eql '200'
  end

end

