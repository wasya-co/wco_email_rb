
class WcoEmail::ConversationsController < WcoEmail::ApplicationController

  # layout 'wco_email/mailbox'

  before_action :set_lists
  before_action :find_convs_tags, only: %i| addtag rmtag |

  ## many tags to many convs
  def addtag
    authorize! :addtag, WcoEmail::Conversation

    inbox = Wco::Tag.inbox
    outs = @convs.map do |conv|
      conv.tags.push @tags
      conv.tags.delete( inbox ) if params[:is_move]
      conv.save
    end
    flash_notice "Outcomes: #{outs}"

    render json: { status: 'ok' }
    # redirect_to request.referrer # || root_path
  end

  def edit
    @conversation = ::WcoEmail::Conversation.find( params[:id] )
    authorize! :edit, @conversation
  end

  def index
    authorize! :index, WcoEmail::Conversation
    @conversations = WcoEmail::Conversation.all

    if params[:tagname]
      @tag = Wco::Tag.find_by slug: params[:tagname]
      @conversations = @conversations.where( :tag_ids.in => [ @tag.id ] )
    end
    if params[:tagname_not]
      @tag_not = Wco::Tag.find_by slug: params[:tagname_not]
      @conversations = @conversations.where( :tag_ids.nin => [ @tag_not.id ] )
    end

    if params[:subject].present?
      @conversations = @conversations.where({ subject: /.*#{params[:subject]}.*/i })
    end

    if params[:from_email].present?
      @conversations = @conversations.where({ from_emails: /.*#{params[:from_email]}.*/i })
    end

    @conversations = @conversations.order_by( latest_at: :desc
      ).includes( :leads, :messages
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

  def rmtag
    authorize! :addtag, WcoEmail::Conversation

    outs = @convs.map do |conv|
      @tags.map do |tag|
        conv.tags.delete( tag )
      end
      conv.save
    end
    flash_notice "Outcomes: #{outs}"
    render json: { status: 'ok' }
    # redirect_to request.referrer || root_path
  end

  def show
    @conversation = ::WcoEmail::Conversation.find( params[:id] )
    authorize! :show, @conversation
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

  def update
    @conversation = ::WcoEmail::Conversation.find( params[:id] )
    authorize! :update, @conversation
    if @conversation.update( params[:conversation].permit! )
      flash_notice 'ok'
    else
      flash_alert @conversation
    end
    redirect_to action: 'show', id: @conversation.id
  end

  ##
  ## private
  ##
  private

  def find_convs_tags
    @convs = WcoEmail::Conversation.find params[:ids]
    @tags  = Wco::Tag.where({ :slug.in => params[:slug].split(",") })
    if @tags.blank?
      @tags  = Wco::Tag.where({ :id.in => params[:slug].split(",") })
    end
  end

  def set_lists
    @tags       = Wco::Tag.all
    @email_templates_list = [ [nil, nil] ] + WcoEmail::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
    @leads_list = Wco::Lead.list
    @tags_list  = Wco::Tag.list
  end

end



