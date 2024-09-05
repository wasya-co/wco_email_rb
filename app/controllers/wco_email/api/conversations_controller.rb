
class WcoEmail::Api::ConversationsController < WcoEmail::ApiController

  def index
    authorize! :index, WcoEmail::Conversation
    @conversations, @messages, @tag = WcoEmail::Conversation.load_conversations_messages_tag_by_params_and_profile( params, current_profile )
  end

end

