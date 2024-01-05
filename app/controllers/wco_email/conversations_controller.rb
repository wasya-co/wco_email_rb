
class WcoEmail::ConversationsController < WcoEmail::ApplicationController

  layout 'wco_email/mailbox'

  def index
    authorize! :index, WcoEmail::Conversation
    @email_conversations = WcoEmail::Conversation.all.order_by({ latest_at: :desc })

    per_page = current_profile.per_page
    # if current_profile.per_page > 100
    #   flash_notice "Cannot display more than 100 conversations per page."
    #   per_page = 100
    # end

    if params[:tagname]
      tag = Wco::Tag.find_by slug: params[:tagname]
      @email_conversations = @email_conversations.where( :tag_ids.in => [ tag.id ] )
    end
    if params[:tagname_not]
      tag_not = Wco::Tag.find_by slug: params[:tagname_not]
      @email_conversations = @email_conversations.where( :tag_ids.nin => [ tag_not.id ] )
    end

    if params[:subject].present?
      @email_conversations = @email_conversations.where({ subject: /.*#{params[:subject]}.*/i })
    end

    if params[:from_email].present?
      @email_conversations = @email_conversations.where({ from_emails: /.*#{params[:from_email]}.*/i })
    end

    @email_conversations = @email_conversations.order_by( latest_at: :desc
      # ).includes( :email_messages
      ).page( params[:conv_page]
      ).per( per_page
      )
  end

  ## merge conv1 into conv2, and delete conv1
  def merge
    authorize! :email_conversations_merge, Ability
    conv1 = WcoEmail::Conversation.find params[:id1]
    conv2 = WcoEmail::Conversation.find params[:id2]
    conv1.messages.map do |msg|
      msg.update conversation: conv2
    end
    conv1.tags.map do |tag|
      conv2.tags.push tag
    end
    conv1.leads.map do |lead|
      conv2.leads.push lead
    end
    conv2.save!
    conv1.delete

    flash_notice "Probably ok"
    redirect_to action: :show, id: conv2.id
  end

  def show
    authorize! :email_conversations_show, Ability
    @conversation = ::WcoEmail::Conversation.find( params[:id] )
    @messages     = @conversation.messages.order_by( date: :asc )
    @conversation.update_attributes({ status: Conv::STATUS_READ })

    @other_convs = WcoEmail::Message.where( :message_id.in => @messages.map( &:in_reply_to_id )
      ).where( :conversation_id.ne => @conversation.id
      ).map( &:conversation_id ).uniq
    other_convs_by_subj = WcoEmail::Conversation.where( subject: @conversation.subject
      ).where( :conversation_id.ne => @conversation.id
      ).map( &:id )
    if @other_convs.present?
      @other_convs = WcoEmail::Conversation.find( @other_convs + other_convs_by_subj )
    end

  end

end

