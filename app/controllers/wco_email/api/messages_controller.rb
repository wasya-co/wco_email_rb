
class WcoEmail::Api::MessagesController < WcoEmail::ApiController

  before_action      :check_credentials, only: [ :create_postal, :create_ses, :postal_webhook ]
  before_action      :decode_jwt,      except: [ :create_postal, :create_ses, :postal_webhook ]


  ## 2026-03-27 payload is parsed json.
  def create_postal
    # puts! params, 'api/messages#create_postal'

    generated_message_id = "<#{SecureRandom.uuid}@wasya-generated>"

    ## save to bucket
    @client ||= Aws::S3::Client.new(::SES_S3_CREDENTIALS)
    @client.put_object({
      body:          params.to_unsafe_h.to_json,
      bucket:      ::SES_S3_BUCKET,
      content_type: 'application/json',
      key:           params['message_id'] || generated_message_id,
    })

    stub = WcoEmail::MessageStub.create!({
      bucket:   ::SES_S3_BUCKET,
      format:    'json',
      object_key: params['message_id'] || generated_message_id,
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end

  def create_ses
    # puts! params, 'params'
    stub = WcoEmail::MessageStub.find_or_create_by({
      bucket:     params[:bucket],
      format:    'raw',
      object_key: params[:object_key],
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end

=begin

{
  "message": {
    "id": 1778,
    "direction": "outgoing",
    "message_id": "6a595d99629a1_7dfe84558@245533f3cb05.mail",
    "to": "poxlovi@gmail.com",
    "from": "no-reply@wasya.co",
    "subject": "tasty 16d test",
    "timestamp": 1784241561.520441,
    "spam_status": "NotChecked",
    "tag": null
  },
  "status": "Sent",
  "details": "Message for poxlovi@gmail.com accepted by 142.251.2.27:25 (gmail-smtp-in.l.google.com)",
  "output": "250 2.0.0 OK  1784241562 5a478bee46e88-3142a267131si91362eec.61 - gsmtp",
  "sent_with_ssl": true,
  "timestamp": 1784241562.9551728,
  "time": 0.64
}


{
  "message": {
    "id": 1786,
    "token": "P6V8T55pRllHYS2w",
    "direction": "outgoing",
    "message_id": "6a595dcc152e2_7dea8459f5@245533f3cb05.mail",
    "to": "robferrell1@hotmail.com",
    "from": "no-reply@wasya.co",
    "subject": "Using cursor is infuriating - AI makes you dumb",
    "timestamp": 1784241612.205367,
    "spam_status": "NotChecked",
    "tag": null
  },
  "status": "HardFail",
  "details": "Permanent SMTP delivery error when sending to 52.101.68.20:25 (hotmail-com.olc.protection.outlook.com)",
  "output": "550 5.7.1 Unfortunately, messages from [167.172.221.28] weren't sent. Please contact your Internet service provider since part of their network is on our block list (S3140). You can also refer your provider to http://mail.live.com/mail/troubleshootin",
  "sent_with_ssl": false,
  "timestamp": 1784241616.289614,
  "time": 0.13
}

=end
  ##
  ## SoftFail , Sent
  ##
  def postal_webhook
    payload = params['payload']
    if [ 'SoftFail', 'HardFail' ].include?( payload['status'] )
      lead = Wco::Lead.where( email: payload['message']['to'].downcase ).first
      if lead
        lead.tags.push Wco::Tag.bounced
        lead.save!
      end
    end

    render status: :ok, json: { status: :ok }
  end


end





