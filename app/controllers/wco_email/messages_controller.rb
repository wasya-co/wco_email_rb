
class WcoEmail::MessagesController < WcoEmail::ApplicationController

  before_action :set_lists, except: %i| show_iframe |

  def show
    @message = WcoEmail::Message.find params[:id]

    @client ||= Aws::S3::Client.new({
      region:            ::S3_CREDENTIALS[:region_ses] || 'us-east-1',
      access_key_id:     ::S3_CREDENTIALS[:access_key_id_ses],
      secret_access_key: ::S3_CREDENTIALS[:secret_access_key_ses],
    })
    stub     = @message.stub
    raw      = @client.get_object( bucket: stub.bucket, key: stub.object_key ).body.read
    raw      = raw.encode('utf-8', invalid: :replace, undef: :replace, replace: '_' )
    @the_mail = Mail.new( raw )

    authorize! :show, @message
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

