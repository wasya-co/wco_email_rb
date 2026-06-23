
class WcoEmail::Api::EmailFiltersController < WcoEmail::ApiController

  def create
    authorize! :create, WcoEmail::EmailFilter
    @item = ::WcoEmail::EmailFilter.new email_filter_pparams

    if @item.save
      render json: { id: @item.id.to_s }, status: :ok
    else
      puts! @item.errors.full_messages, 'could not api-create EmailFilter'
      render json: { messages: @item.errors.full_messages }, status: 400
    end
  end

  def destroy
    @item = ::WcoEmail::EmailFilter.find params[:id]
    authorize! :destroy, @item
    if @item.delete
      render json: {  }, status: :ok
    else
      render json: { messages: @item.errors.full_messages }, status: 400
    end
  end

  def index
    authorize! :index, WcoEmail::EmailFilter
    @items = ::WcoEmail::EmailFilter.all
    # respond_to do |format|
    #   format.json do
    #     render
    #   end
    # end
  end

  def show
    @filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :show, @filter
  end

  def update
    @filter = WcoEmail::EmailFilter.find params[:id]
    authorize! :update, @filter

    if @filter.update email_filter_pparams
      render json: { messages: [ 'Updated the email filter.' ] }, status: :ok
    else
      render json: { messages: @filter.errors.full_messages +
        @filter.actions.map { |k| k.errors.full_messages } +
        @filter.conditions.map { |k| k.errors.full_messages } +
        @filter.skip_conditions.map { |k| k.errors.full_messages }
      }, status: 400
    end
  end

  ##
  ## private
  ##
  private

  def email_filter_pparams
    params[:email_filter].permit({
      actions_attributes:         [ :aject_id, :aject_type, :id, :_destroy,         :kind,            :value ],
      conditions_attributes:      [                         :id, :_destroy, :field,        :operator, :value ],
      skip_conditions_attributes: [ :aject_id, :aject_type, :id, :_destroy, :field,        :operator, :value ],
    })
  end


end

