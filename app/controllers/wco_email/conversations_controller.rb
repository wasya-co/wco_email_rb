
class WcoEmail::ConversationsController < WcoEmail::ApplicationController

  # layout 'wco_email/mailbox'

  before_action :set_lists

  ## many tags to many convs
  def addtag
    authorize! :addtag, WcoEmail::Conversation
    # convs = WcoEmail::Conversation.where({ :id.in => params[:ids].split(",") })
    convs = WcoEmail::Conversation.find( params[:ids] )
    tags  = Wco::Tag.where({ :slug.in => params[:slug].split(",") })
    if tags.blank?
      tags  = Wco::Tag.where({ :id.in => params[:slug].split(",") })
    end
    inbox = Wco::Tag.inbox
    outs = convs.map do |conv|
      conv.tags.push tags
      conv.tags.delete( inbox ) if params[:is_move]
      conv.save
    end
    flash_notice "Outcomes: #{outs}"
    redirect_to request.referrer || root_path
  end

  # def delete
  #   authorize! :delete, WcoEmail::Conversation
  #   convs = WcoEmail::Conversation.find params[:ids]
  #   outs = convs.map do |conv|
  #     conv.add_tag( WpTag::TRASH )
  #     conv.remove_tag( WpTag::INBOX )
  #   end
  #   flash[:notice] = "outcome: #{outs}"
  #   render json: { status: :ok }
  # end

  def index
    authorize! :index, WcoEmail::Conversation
    @conversations = WcoEmail::Conversation.all

    if params[:tagname]
      tag = Wco::Tag.find_by slug: params[:tagname]
      @conversations = @conversations.where( :tag_ids.in => [ tag.id ] )
    end
    if params[:tagname_not]
      tag_not = Wco::Tag.find_by slug: params[:tagname_not]
      @conversations = @conversations.where( :tag_ids.nin => [ tag_not.id ] )
    end

    if params[:subject].present?
      @conversations = @conversations.where({ subject: /.*#{params[:subject]}.*/i })
    end

    if params[:from_email].present?
      @conversations = @conversations.where({ from_emails: /.*#{params[:from_email]}.*/i })
    end

    @conversations = @conversations.order_by( latest_at: :desc
      ).includes( :leads
      ).page( params[:conv_page]
      ).per( current_profile.per_page
      )
  end

  ## merge conv1 into conv2, and delete conv1
  def merge
    authorize! :merge, WcoEmail::Conversation
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

  #
  def rmtag
    authorize! :addtag, WcoEmail::Conversation
    convs = WcoEmail::Conversation.find params[:ids]
    outs = convs.map do |conv|
      conv.remove_tag( params[:emailtag] )
    end
    flash[:notice] = "outcome: #{outs}"
    redirect_to request.referrer
  end

  def show
    authorize! :show, WcoEmail::Conversation
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


  ##
  ## private
  ##
  private

  def set_lists
    @tags       = Wco::Tag.all
    @email_templates_list = [ [nil, nil] ] + WcoEmail::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
    @leads_list = Wco::Lead.list
    @tags_list  = Wco::Tag.list
  end

end

