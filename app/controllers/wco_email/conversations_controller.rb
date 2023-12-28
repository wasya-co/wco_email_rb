
class WcoEmail::ConversationsController < Wco::ApplicationController

  # before_action :set_lists, except: [ :index ]

  layout 'wco_email/application'

  def index
    authorize! :index, WcoEmail::Conversation
    @email_conversations = WcoEmail::Conversation.all

    # @new_tag = WpTag.new
    # @emailtags = WpTag.emailtags
    # @emailtags_list = [[nil,nil]] + WpTag.emailtags.map { |p| [ p.name, p.slug ] }

    per_page = current_profile.per_page
    # if current_profile.per_page > 100
    #   flash_notice "Cannot display more than 100 conversations per page."
    #   per_page = 100
    # end

    if params[:tagname]
      tag = Wco::Tag.find_by slug: params[:tagname]
      @email_conversations = @email_conversations.where( :tag_ids.in => [ tag.id ] )
    end

    return # herehere






    if params[:tagname_not]
      @email_conversations = @email_conversations.not_in_emailtag( params[:not_slug] )
    end

    if params[:subject].present?
      @email_conversations = @email_conversations.where({ subject: /.*#{params[:subject]}.*/i })
    end

    if params[:from_email].present?
      @email_conversations = @email_conversations.where({ from_emails: /.*#{params[:from_email]}.*/i })
    end

    @email_conversations = @email_conversations.order_by( latest_at: :desc
      ).includes( :email_messages # , :lead_ties
      # ).page( params[:conv_page]
      # ).per( per_page
      )
  end


  def show
    authorize! :email_conversations_show, Ability
    @conversation = ::WcoEmail::Conversation.find( params[:id] )
    @messages     = @conversation.messages.order_by( date: :asc )
    @conversation.update_attributes({ status: Conv::STATUS_READ })
  end

end

