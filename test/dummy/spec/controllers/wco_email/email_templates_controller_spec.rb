
describe WcoEmail::EmailTemplatesController do
  render_views
  routes { WcoEmail::Engine.routes }

  before do
    Wco::Lead.unscoped.map &:destroy!
    WcoEmail::EmailActionTemplate.unscoped.map &:destroy!
    WcoEmail::EmailTemplate.unscoped.map &:destroy!
    @eat = create( :email_action_template )

    setup_users
  end

  describe "#index" do
    it 'sanity, _index_expanded' do
      get :index
      response.code.should eql '200'
      assigns( :templates ).length.should > 0

      get :index, params: { view: '_index_expanded' }
      response.code.should eql '200'
      assigns( :templates ).length.should > 0
    end

    it 'search' do
      q = 'pri'
      create( :email_template, slug: "xx#{q}xx" )

      get :index, params: { q: q }

      outs = assigns( :templates )
      outs.length.should > 0
      outs.each do |out|
        out.slug.include?( q ).should eql true
      end
    end
  end

  it '#new' do
    get :new
    response.code.should eql '200'
  end

  describe '#show' do
    it 'sanity' do
      WcoEmail::EmailTemplate.unscoped.map &:destroy!
      tmpl = create( :email_template )

      get :show, params: { id: tmpl.id }
      response.code.should eql '200'
    end
  end


end

