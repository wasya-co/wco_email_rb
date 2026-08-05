
WcoEmail::ApiController::AWS_SES_LAMBDA_SECRET ||= 'secret'

describe WcoEmail::Api::MessagesController do
  render_views
  routes { WcoEmail::Engine.routes } ## requried


  describe '#postal_webhook' do
    it 'HardFail' do
      destroy_every( Wco::Lead )
      lead = create(:lead, email: 'pax@gmail.com' )

      ( lead.tags & [ Wco::Tag.bounce ]).length.should eql 0
      post :postal_webhook, params: { secret: 'secret', payload: { secret: 'secret', status: 'HardFail', message: { to: 'pax@gmail.com' } } }


      lead.reload
      ( lead.tags & [ Wco::Tag.bounced ]).length.should eql 1
    end
  end
end
