
class WcoEmail::Api::ConversationsController < WcoEmail::ApiController

  def destroy_many
    authorize! :edit, WcoEmail::Conversation
    @convs = WcoEmail::Conversation.find( params[:ids] )
    @convs.each { |c| c.destroy! }
    render json: { status: 'ok', message: 'probably ok' }
  end

  def index
    authorize! :index, WcoEmail::Conversation
    @conversations, @messages, @tag = WcoEmail::Conversation.load_conversations_messages_tag_by_params_and_profile( params, current_profile )
  end

end

