
require 'aws-sdk-s3'
require 'mail'
require 'sidekiq'
require 'exception_notification'

##
## 2023-02-26 _vp_ Let's go
## 2023-03-07 _vp_ Continue
## 2023-12-28 _vp_ Continue
##
class WcoEmail::MessageIntakeJob
  include Sidekiq::Job

  sidekiq_options queue: 'wco_email_rb'

=begin

  ## Mongo::Error::MaxBSONSize: The document exceeds maximum allowed BSON object size after serialization (on 10.138.2.145)
  object_key = 'k9n9qo03fii2in3ocj977nac0vj5djn07e110bg1'

  object_key = 'hlbg24s1ov5k7irgmqsrjp0kl95vpik8t1esvs81'
  MsgStub.where({ object_key: object_key }).delete

  stub = MsgStub.create!({ object_key: object_key })
  id = stub.id

  Ishapi::EmailMessageIntakeJob.perform_now( stub.id.to_s )

=end
  def perform id
    stub = WcoEmail::MessageStub.find id
    puts "+++ +++ Performing WcoEmail::MessageIntakeJob for object_key `#{stub.object_key}`."

    if [ WcoEmail::MessageStub::STATUS_PROCESSED, WcoEmail::MessageStub::STATUS_FAILED ].include?( stub.status )
      raise "This stub has already been processed, or errored out: #{stub.id.to_s}."
      return
    end

    begin
      stub.do_process
    rescue => err
      stub.update({ status: WcoEmail::MessageStub::STATUS_FAILED })
      puts! err, "WcoEmail::MessageIntakeJob error"
      ::ExceptionNotifier.notify_exception(
        err,
        data: { stub: stub }
      )
    end

  end
end
EIJ = WcoEmail::MessageIntakeJob
