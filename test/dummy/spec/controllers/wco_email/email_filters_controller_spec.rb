
describe WcoEmail::EmailFiltersController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    setup_users
  end

  it '#index' do
    get :index
    response.code.should eql '200'
  end

end

