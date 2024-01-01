
class WcoEmail::MessagesController < WcoEmail::ApplicationController

  def show
    @message = WcoEmail::Message.find params[:id]
    authorize! :show, @message
  end

  def show_iframe
    @message = WcoEmail::Message.find params[:id]
    authorize! :show, @message
    render layout: false
  end

end

