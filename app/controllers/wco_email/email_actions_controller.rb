
class WcoEmail::EmailActionsController < WcoEmail::ApplicationController

  before_action :set_lists

  def create
    @sch = Sch.new( params[:email_action].permit! )
    authorize! :create, @sch

    flag = @sch.save
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@sch.errors.full_messages.join(', ')}"
    end
    redirect_to request.referrer ? request.referrer : leadsets_path
  end

  def edit
    @sch = Sch.find params[:id]
    authorize! :edit, @sch
  end

  def index
    @schs = Sch.all
    authorize! :index, @schs
  end

  def new
    @email_action = WcoEmail::EmailAction.new
    authorize! :new, @sch
  end

  def show
    @sch = Sch.find params[:id]
    authorize! :show, @sch
    redirect_to action: 'edit'
  end

  def update
    @sch = Sch.find params[:id]
    authorize! :update, @sch
    flag = @sch.update_attributes( params[:email_action].permit! )
    if flag
      flash[:notice] = "Success."
    else
      flash[:alert] = "No luck: #{@sch.errors.full_messages.join(',')}."
    end
    render action: 'edit'
  end

  ##
  ## private
  ##
  private

  def set_lists
    @email_action_templates_list = WcoEmail::EmailActionTemplate.list
    @leads_list = Wco::Lead.list
  end

end

