
describe WcoEmail::EmailFiltersController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    setup_users
    destroy_every(
      Wco::Lead,
      WcoEmail::EmailActionTemplate,
      WcoEmail::EmailAction,
      WcoEmail::EmailFilterAction,
      WcoEmail::EmailFilterCondition,
      WcoEmail::EmailTemplate,
    );
    @email_filter = create(:email_filter, slug: 'default-filter' )
  end

  it '#index, search' do
    get :index
    response.code.should eql '200'

    @email_filter_2 = create(:email_filter, slug: 'from-z' )
    @email_cond_2   = create(:email_filter_condition, email_filter: @email_filter_2,
      field: EFC::FIELD_FROM,
      operator: EFC::OPERATOR_MATCH,
      value: 'from-z',
    );
    get :index, params: { q: 'from-z' }
    outs = assigns( :email_filters ).map &:_id
    outs.include?( @email_filter_2.id ).should eql true
    outs.include?( @email_filter.id   ).should eql false
  end

  it '#show' do
    get :show, params: { id: @email_filter.id }
    response.code.should eql '200'
  end

end

