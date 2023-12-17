
describe WcoEmail::ApplicationController, :type => :controller do

  render_views
  routes { WcoEmail::Engine.routes }

  before do
    User.all.destroy_all
    user = User.create!( email: 'victor@wasya.co', password: 'test1234', provider: 'keycloakopenid' )
    Wco::Profile.all.destroy_all
    p = Wco::Profile.create!( email: user.email )
    sign_in user
  end

  describe 'routes' do
    it 'does' do
      # expect(get: '/email_conversations').to              route_to(controller: 'wco/email_conversations', action: 'index')
    end
  end

  it "#home" do
    get :home
    response.code.should eql '200'
  end
end

