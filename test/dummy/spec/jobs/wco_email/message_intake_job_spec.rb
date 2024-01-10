
RSpec.describe WcoEmail::MessageIntakeJob do
  include ActiveJob::TestHelper

  describe 'test' do

    it 'creates the email_message' do
      object_key = '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
      object_key = 'd5360f5f-d13a-45ca-95b5-abd08af7659a@DTIBiggsSMTP2.state.de.us'

      WcoEmail::Message.unscoped.where({ object_key: object_key }).map &:destroy!
      WcoEmail::Message.unscoped.where({ object_key: object_key }).length.should eql 0

      WcoEmail::MessageStub.unscoped.where({ object_key: object_key }).map &:destroy!
      stub = WcoEmail::MessageStub.create!({
        bucket: ::S3_CREDENTIALS[:bucket_ses],
        object_key: object_key,
      })

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )

      WcoEmail::Message.where({ object_key: object_key }).length.should eql 1

    end

  end

end
