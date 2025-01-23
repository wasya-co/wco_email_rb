
RSpec::describe Wco::TagsController do
  render_views
  routes { Wco::Engine.routes }

  before do
    setup_users

    destroy_every(
      Wco::Tag,
      WcoEmail::MessageStub,
    )
    @tag = create( :tag )
  end

  it '#show - with stubs' do
    stub = create(:message_stub, tags: [ @tag ] )
    stub.persisted?.should eql true
    get :show, params: { id: @tag.id }
    # byebug
    puts! response.body
    response.code.should eql '200'
  end

end
