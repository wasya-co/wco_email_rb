
describe WcoEmail::EmailActionTemplatesController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    Wco::Lead.unscoped.map &:destroy!
    WcoEmail::EmailActionTemplate.unscoped.map &:destroy!
    WcoEmail::EmailTemplate.unscoped.map &:destroy!
    @eat = create( :email_action_template )

    setup_users
  end

  it '#index' do
    get :index
    response.code.should eql '200'
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end

end

