
class WcoEmail::MessagesController < WcoEmail::ApplicationController

  before_action :set_lists, except: %i| show_iframe |

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

