
class WcoEmail::MessagesController < WcoEmail::ApplicationController

  before_action :set_lists, except: %i| show_iframe |

  def autorespond
    @message = WcoEmail::Message.find params[:id]
    authorize! :show, @message

    task = 'You are an administrative assistant. Write a brief email response to the following email. exclude subject. exclude footer. exclude signature. format as <p></p> html paragraphs.'
    content = @message.part_txt
    outs = Wco::AiWriter.do_call(task, content)
    puts! outs, 'outs'


    @ctx = WcoEmail::Context.new({
      bcc_self:            true,
      body:                outs,
      email_template:      WcoEmail::EmailTemplate.blank,
      from_email:          @message.to,
      lead:                @message.lead,
      reply_to_message_id: @message.id,
      # send_at:             Time.now,
      subject:             @message.subject,
    })

    if @ctx.save
      flash_notice 'Saved.'
    else
      flash_alert @ctx
    end
    redirect_to request.referrer
  end

  def show
    @client ||= Aws::S3::Client.new(::SES_S3_CREDENTIALS)
    @message = WcoEmail::Message.find params[:id]
    authorize! :show, @message

    stub     = @message.stub
    raw      = @client.get_object( bucket: stub.bucket, key: stub.object_key ).body.read
    raw      = raw.encode('utf-8', invalid: :replace, undef: :replace, replace: '_' )
    @the_mail = Mail.new( raw )
  end

  def show_iframe
    @message = WcoEmail::Message.find params[:id]
    authorize! :show, @message
    render layout: false
  end

  ##
  ## private
  ##
  private

  def set_lists
    @email_templates_list = WcoEmail::EmailTemplate.list
    @leads_list           = Wco::Lead.list
  end

end

