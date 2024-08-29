
class WcoEmail::EmailFiltersController < WcoEmail::ApplicationController

  before_action :set_lists

  def create
    authorize! :create, WcoEmail::EmailFilter
    @email_filter = WcoEmail::EmailFilter.create params[:email_filter].permit!
    if @email_filter.persisted?
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'new'
  end

  def destroy
    @email_filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :destroy, @email_filter
    flag = @email_filter.destroy
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = 'Error'
    end
    redirect_to action: 'index'
  end

  def edit
    @email_filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :edit, @email_filter
  end

  def index
    authorize! :index, WcoEmail::EmailFilter.new
    @email_filter  = WcoEmail::EmailFilter.new
    @email_filters = WcoEmail::EmailFilter.all().includes( :email_template, :conversations )

    if params[:q]
      @email_filters = @email_filters.where( from_exact: /#{params[:q]}/i )
    end

    @email_filters = @email_filters.page( params[WcoEmail::EmailFilter::PAGE_PARAM_NAME]
      ).per( current_profile.per_page )
  end

  def new
    @email_filter = WcoEmail::EmailFilter.new
    authorize! :new, @email_filter
  end
  def new2
    @email_filter = WcoEmail::EmailFilter.new
    authorize! :new, @email_filter

    @new_email_filter_condition = WcoEmail::EmailFilterCondition.new
  end

  def show
    @email_filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :show, @email_filter
  end

  def update
    @email_filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :update, @email_filter

    if params[:email_filter][:tag].blank?
      params[:email_filter].delete :tag
    end

    flag = @email_filter.update_attributes( params[:email_filter].permit! )
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

  ##
  ## private
  ##
  private

  def set_lists
    @tags_list = Wco::Tag.list
    @email_templates_list        = WcoEmail::EmailTemplate.list
    @email_actions_list          = WcoEmail::EmailAction.list
    @email_action_templates_list = WcoEmail::EmailActionTemplate.list
  end



end

