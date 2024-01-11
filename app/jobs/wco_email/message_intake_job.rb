
require 'aws-sdk-s3'
require 'mail'
require 'sidekiq'

##
## 2023-02-26 _vp_ Let's go
## 2023-03-07 _vp_ Continue
## 2023-12-28 _vp_ Continue
##
## class_name EIJ
##
class WcoEmail::MessageIntakeJob
  include Sidekiq::Job
  # include Sidekiq::Util

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

    if stub.status != WcoEmail::MessageStub::STATUS_PENDING
      raise "This stub has already been processed: #{stub.id.to_s}."
      return
    end

    begin
      stub.do_process
    rescue => err
      puts! err, "WcoEmail::MessageIntakeJob error"
      ExceptionNotifier.notify_exception(
        err,
        data: { stub: stub }
      )
    end

  end
end
EIJ = WcoEmail::MessageIntakeJob
