
describe WcoEmail::EmailActionsController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    destroy_every( Wco::Lead,
      WcoEmail::EmailActionTemplate,
      WcoEmail::EmailAction,
      WcoEmail::EmailTemplate,
    )
    setup_users
    @ea = create( :email_action, {
      email_action_template: create( :email_action_template,
        slug: 'first',
        email_template: create(:email_template) ),
      lead: create(:lead),
    })
    @ea_2 = create( :email_action, {
      email_action_template: create( :email_action_template,
        slug: 'second',
        email_template: create(:email_template,
          slug: 'first') ),
      lead: create(:lead),
    })
    @ea_3 = create( :email_action, {
      email_action_template: create( :email_action_template,
        slug: 'third',
        email_template: create(:email_template) ),
      lead: create(:lead),
    })
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end


  context '#index' do
    it 'searchable' do
      get :index, params: { q: 'First' }
      assigns(:email_actions).length.should > 0
      assigns(:email_actions).each do |ea|
        out = "#{ea.email_action_template} #{ea.lead} #{ea.email_action_template.email_template}".downcase
        out.include?( 'first' ).should eql true
      end
      assigns(:email_actions).map(&:id).include?( @ea.id   ).should eql true
      assigns(:email_actions).map(&:id).include?( @ea_2.id ).should eql true
    end
  end

end

