

describe WcoEmail::Api::EmailTemplatesController do
  render_views
  routes { WcoEmail::Engine.routes }

  describe 'routes' do
    it 'does' do
      expect(get: '/api/email_templates').to route_to(controller: 'wco_email/api/email_templates', action: 'index')
    end
  end

  before do
    setup_users

    destroy_every(
      Wco::Tag,
      WcoEmail::EmailTemplate,
    )
    @inbox = Wco::Tag.inbox

    @tmpl = create( :email_template )
  end

  describe '#index' do
    it 'json api' do
      get :index, format: :json
      response.code.should eql '200'
      rows = JSON.parse( response.body )['items']
      rows.each do |row|
        row['value'].should_not eql nil
      end
    end
  end
end
