
class WcoEmail::Api::MessagesController < WcoEmail::ApiController

  before_action      :check_credentials, only: [ :create_email_message ]
  before_action      :decode_jwt,      except: [ :create_email_message ]


  ## 2026-03-27 payload is parsed json.
  def create_postal
    puts! params, 'api/messages#create_postal'

    ## save to bucket
    @client ||= Aws::S3::Client.new(::SES_S3_CREDENTIALS)
    @client.put_obpect({
      body:          params.to_json,
      bucket:      ::SES_S3_BUCKET,
      content_type: 'application/json',
      key:           params['message_id'],
    })

    stub = WcoEmail::MessageStub.create({
      bucket:   ::SES_S3_BUCKET,
      format:    'json',
      object_key: params['message_id'],
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end


end



  ## from aws ses
  ## raw email
  ## NEVER BEEN USED!
=begin
  def create
    puts! params, 'params'

    stub = WcoEmail::MessageStub.find_or_create_by({
      bucket:     params[:bucket],
      object_key: params[:object_key],
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end
=end