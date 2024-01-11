
class WcoEmail::MessagesController < WcoEmail::ApiController

  before_action :set_lists, except: %i| show_iframe |

  def create_from_ses
    stub = WcoEmail::MessageStub.create!({
      bucket:     params[:bucket],
      object_key: params[:object_key],
    })

    WcoEmail::MessageIntakeJob.perform_async( stub.id.to_s )
    render status: :ok, json: { status: :ok }
  end

  def show
    @message = WcoEmail::Message.find params[:id]
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

