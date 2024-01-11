
describe WcoEmail::EmailTemplatesController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    setup_users
  end


  describe "#index" do
    it 'does' do
      get :index
      response.code.should eql '200'
    end
  end

  describe '#show' do
    it 'does' do
      WcoEmail::EmailTemplate.unscoped.map &:destroy!
      tmpl = create( :email_template )

      get :show, params: { id: tmpl.id }
      response.code.should eql '200'
    end
  end


end

