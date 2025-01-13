
describe WcoEmail::Api::EmailFiltersController do
  render_views
  routes { WcoEmail::Engine.routes }

  # describe 'routes' do
  #   it 'does' do
  #     expect(get: '/api/conversations').to              route_to(controller: 'wco_email/api/conversations', action: 'index')
  #   end
  # end

  before do
    setup_users

    destroy_every(
      Wco::Leadset,
      Wco::Tag,
    )
    @inbox = Wco::Tag.inbox
    @spam  = Wco::Tag.spam
    @trash = Wco::Tag.trash

    @leadset = Wco::Leadset.create!({ company_url: 'abba.com' })
  end

  describe '#create' do
    it 'json api' do
      n = WcoEmail::EmailFilter.all.count
      post :create, params: { email_filter: {
        actions_attributes: [
          { kind: 'autorespond-template', value: '@TODO' },
          { kind: 'remove-tag', value: @inbox.id.to_s },
          { kind: 'add-tag', value: @spam.id.to_s },
        ],
        conditions_attributes: [
          { field: 'leadset', value: @leadset },
        ],
        skip_conditions_attributes: [],
      }}, format: :json
      response.code.should eql '200'
      WcoEmail::EmailFilter.all.count.should eql( n + 1 )
    end
  end
end
