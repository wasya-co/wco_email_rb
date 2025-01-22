
describe WcoEmail::EmailFiltersController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    setup_users
    destroy_every(
      Wco::Lead,
      WcoEmail::EmailActionTemplate,
      WcoEmail::EmailAction,
      WcoEmail::EmailTemplate,
    );
    @email_filter = create(:email_filter)
  end

  it '#index' do
    get :index
    response.code.should eql '200'
  end

  it '#show' do
    get :show, params: { id: @email_filter.id }
    response.code.should eql '200'
  end

end

