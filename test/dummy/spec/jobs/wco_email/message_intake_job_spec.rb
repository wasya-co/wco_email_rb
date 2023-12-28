
RSpec.describe WcoEmail::MessageIntakeJob do
  include ActiveJob::TestHelper

  describe 'test' do
    it 'creates the email_message' do

      n = WcoEmail::Message.all.length

      object_key = '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
      WcoEmail::MessageStub.where({ object_key: object_key }).delete
      stub = WcoEmail::MessageStub.create!({ object_key: object_key })

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )

      WcoEmail::Message.all.length.should eql( n + 1 )

    end
  end

end
