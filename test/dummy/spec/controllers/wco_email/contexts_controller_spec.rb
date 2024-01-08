
describe WcoEmail::ContextsController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    Wco::Lead.unscoped.map &:destroy!
    WcoEmail::EmailTemplate.unscoped.map &:destroy!

    setup_users
  end

  it '#show' do
    ctx = create( :email_context, {
      lead: create(:lead),
      email_template: create(:email_template),
    })

    get :show, params: { id: ctx.id }
    response.code.should eql '200'
  end

end

