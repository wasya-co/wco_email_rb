
describe WcoEmail::Api::EmailFiltersController do
  render_views
  routes { WcoEmail::Engine.routes }

  it 'routes' do
    expect(get: '/api/email_filters').to route_to(controller: 'wco_email/api/email_filters', action: 'index', format: :json )
  end

  before do
    setup_users

    destroy_every(
      Wco::Leadset,
      Wco::Tag,
      WcoEmail::EmailTemplate,
    )
    @inbox = Wco::Tag.inbox
    @spam  = Wco::Tag.spam
    @trash = Wco::Tag.trash
    @not_spam = create( :tag, slug: 'not-spam' )

    @email_template = create(:email_template)
    @leadset = Wco::Leadset.create!({ company_url: 'abba.com' })
  end

  describe '#create, negative' do
    before do
      @n = WcoEmail::EmailFilter.all.count
      @email_filter_params = {
        actions_attributes: [
          { kind: 'autorespond-template', value: @email_template.id.to_s },
        ],
        conditions_attributes: [
          { field: 'leadset', matchtype: 'not-has-tag', value: @not_spam.id.to_s },
        ],
      }
    end

    it 'positive' do
      post :create, params: { email_filter: @email_filter_params }, format: :json
      response.code.should eql '200'
      WcoEmail::EmailFilter.all.count.should eql( @n + 1)
    end


    it 'autorespond-template value must be an existing id' do
      @email_filter_params[:actions_attributes][0][:value] = '@TODO'
      post :create, params: { email_filter: @email_filter_params }, format: :json
      response.code.should eql '400'
      WcoEmail::EmailFilter.all.count.should eql( @n )
    end

    it 'condition operator must be present' do
      @email_filter_params[:conditions_attributes][0][:matchtype] = nil
      post :create, params: { email_filter: @email_filter_params }, format: :json
      response.code.should eql '400'
      result = JSON.parse response.body
      # puts! result, 'result zz1'
      WcoEmail::EmailFilter.all.count.should eql( @n )
    end
  end

  it '#create, #show' do
    n = WcoEmail::EmailFilter.all.count
    post :create, params: { email_filter: {
      actions_attributes: [
        { kind: 'autorespond-template', value: @email_template.id.to_s },
        { kind: 'remove-tag',           value: @inbox.id.to_s },
        { kind: 'add-tag',              value: @spam.id.to_s },
      ],
      conditions_attributes: [
        { field: 'leadset', matchtype: 'equals', value: @leadset.id.to_s },
      ],
      skip_conditions_attributes: [
        { field: 'from',    matchtype: 'equals', value: 'except@this-one.com' },
      ],
    }}, format: :json
    if response.code != '200'
      puts! response.body, 'could not create an EmailFilter'
    end
    response.code.should eql '200'
    id = JSON.parse( response.body )['id']
    id.should_not eql nil
    WcoEmail::EmailFilter.all.count.should eql( n + 1 )
    @filter = WcoEmail::EmailFilter.find id
    @filter.actions[0].kind.should eql WcoEmail::EmailFilter::KIND_AUTORESPOND_TMPL
    @filter.conditions[0].field.should eql 'leadset'
    @filter.skip_conditions[0].field.should eql 'from'

    get :show, params: { id: id }, format: :json

    response.code.should eql '200'
    out = JSON.parse response.body
    out['actions'].length.should > 0
    out['actions'][0]['kind'].should eql 'autorespond-template'
    out['actions'][0]['value'].should eql @email_template.id.to_s
    out['conditions'].length.should > 0
    out['conditions'][0]['field'].should eql 'leadset'
    out['conditions'][0]['matchtype'].should eql ::WcoEmail::MATCHTYPE_EQUALS
    out['conditions'][0]['value'].should eql @leadset.id.to_s

    out['skip_conditions'].length.should > 0
  end

  it '#index' do
    get :index, format: :json
    response.code.should eql '200'
    outs = JSON.parse response.body
    outs['items'].length.should > 0
  end

end
