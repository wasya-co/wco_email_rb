
RSpec.describe WcoEmail::MessageIntakeJob do
  include ActiveJob::TestHelper

  describe 'test' do

    it 'creates the email_message' do
      object_key = '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'

      WcoEmail::Message.where({ object_key: object_key }).destroy
      WcoEmail::Message.where({ object_key: object_key }).length.should eql 0

      WcoEmail::MessageStub.where({ object_key: object_key }).delete
      stub = WcoEmail::MessageStub.create!({ object_key: object_key })

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )

      WcoEmail::Message.where({ object_key: object_key }).length.should eql 1

    end

  end

end
