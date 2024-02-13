
describe WcoEmail::EmailActionsController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    Wco::Lead.unscoped.map &:destroy!
    WcoEmail::EmailTemplate.unscoped.map &:destroy!

    setup_users

    # @ctx = create( :email_context, {
    #   lead: create(:lead),
    #   email_template: create(:email_template),
    # })
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end

  # it '#show' do
  #   get :show, params: { id: @ctx.id }
  #   response.code.should eql '200'
  # end

end

