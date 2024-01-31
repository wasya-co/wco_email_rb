
describe WcoEmail::ContextsController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    destroy_every( Wco::Lead,
      WcoEmail::Context,
      WcoEmail::EmailTemplate )

    setup_users

    @ctx = create( :email_context, {
      lead: create(:lead),
      email_template: create(:email_template),
    })
    # @ctx_no_tmpl = create( :email_context, {
    #   lead: create(:lead),
    # })
  end

  it '#edit' do
    get :edit, params: { id: @ctx.id }
    response.code.should eql '200'
  end

  it '#index' do
    get :index
    assigns(:ctxs).length.should > 0
    response.code.should eql '200'
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end

  it '#show' do
    get :show, params: { id: @ctx.id }
    response.code.should eql '200'
  end

end

