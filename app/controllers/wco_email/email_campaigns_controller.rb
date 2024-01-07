
EmailCampaign = WcoEmail::Campaign

##
## Campaigns send individual contexts to leads.
##
class WcoEmail::EmailCampaignsController < WcoEmail::ApplicationController

  before_action :set_lists

  def create
    @campaign = EmailCampaign.new params[:campaign].permit!
    authorize! :create, @campaign
    if @campaign.save
      flash[:notice] = "created campaign"
    else
      flash[:alert] = "Cannot create campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def do_send
    @campaign = EmailCampaign.find params[:id]
    authorize! :send, @campaign
    @campaign.do_send
  end

  def edit
    @campaign = EmailCampaign.find params[:id]
    authorize! :edit, @campaign
  end

  def index
    authorize! :index, EmailCampaign
    @campaigns = EmailCampaign.all
  end

  def new
    @campaign = EmailCampaign.new
    authorize! :new, @campaign
  end

  def show
    @campaign = EmailCampaign.find params[:id]
    authorize! :show, @campaign
    @leads = @campaign.leads
    if params[:q].present?
      @leads = @leads.where(" email LIKE ? ", "%#{params[:q]}%" )
    end
    @leads = @leads.page( params[:leads_page ] ).per( current_profile.per_page )
  end

  def update
    @campaign = EmailCampaign.find params[:id]
    authorize! :update, @campaign
    if @campaign.update_attributes params[:campaign].permit!
      flash[:notice] = 'Successfully updated campaign.'
    else
      flash[:alert] = "Cannot update campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  ##
  ## private
  ##
  private

  def set_lists
    @email_templates_list = WcoEmail::EmailTemplate.list
  end

end
