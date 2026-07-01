
class WcoEmail::MessagesController < WcoEmail::ApplicationController

  before_action :set_lists, except: %i| show_iframe |

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

