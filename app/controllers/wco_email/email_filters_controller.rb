
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
  def edit2
    @email_filter = WcoEmail::EmailFilter.find( params[:id] )
    authorize! :edit, @email_filter

    # @new_email_filter_condition = WcoEmail::EmailFilterCondition.new
    @email_filter.conditions.build
    @email_filter.skip_conditions.build
    @email_filter.actions.build

    @aject_options = {
      'none' => [ [nil,nil] ],
      'Wco::Tag' => Wco::Tag.all.map { |t| [t.slug, "Wco::Tag #{t.id}" ] },
      'WcoEmail::EmailTemplate' => WcoEmail::EmailTemplate.all.map { |t| [ t.slug, "WcoEmail::EmailTemplate #{t.id}" ] },
    }
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

=begin
    params[:email_filter][:actions_attributes].each do |_key, attrs|
      puts! attrs, 'attrs 1'

      if '' == attrs[:kind] && '' == attrs[:aject]
        next ## don't save new empty
      end


      if attrs[:id]
        action = WcoEmail::EmailFilterAction.find attrs[:id]
      else
        action = WcoEmail::EmailFilterAction.new({ email_filter_id: params[:id] })
      end

      if '1' == attrs.delete( :_destroy )
        action.destroy!
      else
        type, id = attrs.delete(:aject).split(' ')
        attrs[:aject_type] = type
        attrs[:aject_id] = id

        puts! attrs, 'attrs 2'

        action.update!(attrs.permit!)
      end

    end
=end

    params[:email_filter][:actions_attributes].each do |_key, attrs|
      type, id = attrs.delete(:aject).split(' ')
      attrs[:aject_type] = type
      attrs[:aject_id] = id
    end

    # if params[:email_filter][:tag].blank?
    #   params[:email_filter].delete :tag
    # end

    flag = @email_filter.update_attributes( params[:email_filter].permit! )

    if flag
      flash[:notice] = 'Success'
      redirect_to request.referrer
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
      redirect_to request.referrer
    end

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

