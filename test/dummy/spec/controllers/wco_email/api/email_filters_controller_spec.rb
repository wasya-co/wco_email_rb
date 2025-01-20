
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
      WcoEmail::EmailFilter,
      WcoEmail::EmailFilterCondition,
      WcoEmail::EmailTemplate,
    )
    @inbox    = Wco::Tag.inbox
    @spam     = Wco::Tag.spam
    @trash    = Wco::Tag.trash
    @not_spam = create( :tag, slug: 'not-spam' )

    @email_template = create(:email_template)
    @leadset_1 = create( :leadset, { email: 'test-1@leadset-1.com' })
    @leadset_2 = create( :leadset, { email: 'test-1@leadset-2.com' })

    @filter = create( :email_filter )
  end

  describe '#create, negative' do
    before do
      @n = WcoEmail::EmailFilter.all.count
      @email_filter_params = {
        actions_attributes: [
          { kind: 'autorespond-template', value: @email_template.id.to_s },
        ],
        conditions_attributes: [
          { field: 'leadset', operator: WcoEmail::OPERATOR_NOT_HAS_TAG, value: @not_spam.id.to_s },
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
      @email_filter_params[:conditions_attributes][0][:operator] = nil
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
        { field: 'leadset', operator: 'equals', value: @leadset_1.id.to_s },
      ],
      skip_conditions_attributes: [
        { field: 'from',    operator: 'equals', value: 'except@this-one.com' },
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

    ##
    ## show()
    ##
    get :show, params: { id: id }, format: :json

    response.code.should eql '200'
    out = JSON.parse response.body
    out['actions'].length.should > 0
    out['actions'][0]['id'].should_not eql nil
    out['actions'][0]['kind'].should eql 'autorespond-template'
    out['actions'][0]['value'].should eql @email_template.id.to_s

    out['conditions'].length.should > 0
    out['conditions'][0]['id'].should_not eql nil
    out['conditions'][0]['field'].should eql 'leadset'
    out['conditions'][0]['operator'].should eql ::WcoEmail::OPERATOR_EQUALS
    out['conditions'][0]['value'].should eql @leadset_1.id.to_s

    out['skip_conditions'].length.should > 0
    out['skip_conditions'][0]['id'].should_not eql nil
  end

  it '#index' do
    get :index, format: :json
    response.code.should eql '200'
    outs = JSON.parse response.body
    outs['items'].length.should > 0
  end

  ## @TODO: I can validate A LOT that a faulty filter cannot be created...
  it '#update, remove a condition' do
    attrs = {
      conditions_attributes: @filter.conditions.map { |cond|
        { id: cond.id, field: cond.field, operator: cond.operator, value: cond.value }
      },
    }
    attrs[:conditions_attributes].push({ field: 'leadset', operator: 'equals', value: @leadset_2 })
    post :update, params: { id: @filter.id, email_filter: attrs }
    @filter.reload
    @filter.conditions.length.should eql 2

    remaining_id = @filter.conditions[1].id
    attrs = {
      conditions_attributes: [
        { id: @filter.conditions[0].id, _destroy: '1' },
        { id: @filter.conditions[1].id, _destroy: '0' },
      ],
    }
    post :update, params: { id: @filter.id, email_filter: attrs }
    @filter.reload
    @filter.conditions.length.should eql 1
    @filter.conditions.first.id.should eql remaining_id
  end

end
